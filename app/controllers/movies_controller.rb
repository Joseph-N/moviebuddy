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
		@comment = @movie.comments.build
		@comments = @movie.comments
		@trailer = youtubeVideo(@movie.youtube_identifier)
	end

	def fetch
		@movie = @tmdb.movieInfo(params[:id])
		@trailer = @tmdb.movieTrailer(@movie["id"])
		genres = []
  		@movie["genres"].each do |genre|
        	genres.push(genre["name"])
		end
		@genres = genres
	end

	def create
		@movie = current_user.movies.build(movie_params)
		unless current_user.movies.where(:tmdb_id => @movie.tmdb_id).any?
			if @movie.save
				flash[:notice] = "Added #{@movie.title} successfully to your collection"
				create_update(@movie)
				ActivityWorker.perform_async("Movie", @movie.id, current_user.id)
				if params[:movie][:facebook] == "1"
					ShareWorker.perform_async("facebook", "Movie", current_user.id, @movie.id, { activity: "movie.create", url: movie_url(@movie)})
				end
			end
		else
			flash[:alert] = "#{@movie.title} is already in your collection"
		end

		respond_to do |format|
			format.json { render json: { :url => movies_path} }
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

	private
		def movie_params
			params.require(:movie).permit(:title, :tmdb_id, :overview, :poster, :comment,
											:youtube_identifier, :tag_line, :release_date, 
											:homepage,  :backdrop, :budget, genres: [])
		end

		def init_tmdb
			@tmdb = Tmdb.new
		end

		def create_update(movie)
			if movie.comment?
				current_user.updates.create(content: movie.comment, movie: movie.id)
			else
				current_user.updates.create(movie: movie.id)
			end
		end
end