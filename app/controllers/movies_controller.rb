class MoviesController < ApplicationController
	before_filter :authenticate_user!, :except => [:show]
	before_action :init_tmdb, only: [:index, :show, :fetch]

	def index
		if params[:q]
			raw_movies = @tmdb.searchMovie(params[:q])
			@movies = raw_movies["results"].delete_if { |x| x.nil? }
		else
			@movies = current_user.movies
			@genres = user_movie_genres(current_user)
		end
		respond_to do |format|
			format.html
			format.js
		end
	end

	def show
		@movie = Movie.friendly.find(params[:id])
		@review = @movie.reviews.build
		@reviews = @movie.reviews
		@trailer = youtubeVideo(@movie.youtube_identifier)
	end

	def create
		@movie = current_user.movies.build(movie_params)
		unless current_user.movies.where(:tmdb_id => @movie.tmdb_id).any?
			if @movie.save
				gflash :success => "Added #{@movie.title} successfully to your collection"
				current_user.updates.create(movie: @movie.id)
				ActivityWorker.perform_async("Movie", @movie.id, current_user.id)
				if params[:movie][:facebook] == "1"
					ShareWorker.perform_async("facebook", "Movie", current_user.id, @movie.id, { activity: "movie.create", url: movie_url(@movie)})
				end
			end
		else
			@movie = current_user.movies.find_by_tmdb_id(@movie.tmdb_id)
			gflash :notice => { :value => "#{@movie.title} is already in your collection", :time => 3000 }
		end

		respond_to do |format|
			format.js
			format.html { redirect_to movies_path}
		end
	end

	def vote
		@movie = Movie.friendly.find(params[:id])
		if params[:vote] == 'up'
			if current_user.voted_on?(@movie)
				current_user.vote_exclusively_for(@movie)
			else
				current_user.vote_for(@movie)
			end
			ActivityWorker.perform_async("Movie", @movie.id, current_user.id, { key: "movie.like", action: "vote"})
			ShareWorker.perform_async("facebook", "Movie", current_user.id, @movie.id, { activity: "movie.like", url: movie_url(@movie)} )
			MailerWorker.perform_async(@movie.user.id, "movieLike", { actor_id: current_user.id, movie_id: @movie.id })

		elsif params[:vote] == 'down'
			if current_user.voted_on?(@movie)
        		current_user.vote_exclusively_against(@movie)
        	else
				current_user.vote_against(@movie)
			end
			ActivityWorker.perform_async("Movie", @movie.id, current_user.id, { key: "movie.dislike", action: "vote"})

		end
		respond_to do |format|
			format.html { redirect_to movie_path(@movie) }
			format.js
		end
	end

	def genre_movies
		@genre = params[:name]
	end

	private
		def movie_params
			params.require(:movie).permit(:title, :tmdb_id, :overview, :poster, :tag_line,
											:youtube_identifier, :release_date, :homepage, 
											 :backdrop, :budget, genres: [])
		end

		def init_tmdb
			@tmdb = Tmdb.new
		end
end