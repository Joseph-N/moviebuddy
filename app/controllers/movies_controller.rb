class MoviesController < ApplicationController
	before_filter :authenticate_user!
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
		@movie = Movie.find(params[:id])
		@comment = @movie.comments.build
		@comments = @movie.comments
		@trailer = youtubeVideo(@movie.youtube_id)
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
		@movie = Movie.new(movie_params)
		@movie.user_id = current_user.id
		if @movie.save
			create_update(@movie)
			@movie.create_activity :create, owner: current_user

			respond_to do |format|
				format.json { render json: {"url" => movies_path} }
				format.html { redirect_to movies_path}
			end
		end
	end

	def vote
		@movie = Movie.find(params[:id])
		if params[:vote] == 'up'
			if current_user.voted_on?(@movie)
				current_user.vote_exclusively_for(@movie)
			else
				current_user.vote_for(@movie)
			end
			@movie.create_activity key: 'movie.like', owner: current_user, recipient: @movie, action: 'vote'

		elsif params[:vote] == 'down'
			if current_user.voted_on?(@movie)
        		current_user.vote_exclusively_against(@movie)
        	else
				current_user.vote_against(@movie)
			end
			@movie.create_activity key: 'movie.dislike', owner: current_user, recipient: @movie, action: 'vote'

		end
		respond_to do |format|
			format.html { redirect_to movie_path(@movie) }
			format.js
		end
	end

	private
		def movie_params
			params.require(:movie).permit(:title, :tmdb_id, :overview, :poster, :comment, :youtube_id, :tag_line, :release_date, :homepage,  :backdrop, :budget, genres: [])
		end

		def init_tmdb
			@tmdb = Tmdb.new
		end

		def create_update(movie)
			if movie.comment?
				current_user.updates.create(content: "Added new movie: <b><a href=" + movie_path(movie) + ">#{movie.title}</a></b><p> #{movie.comment}</p>", poster: @movie.poster)
			else
				current_user.updates.create(content: "Added new movie: <b><a href=" + movie_path(movie) + ">#{movie.title}</a></b>", poster: @movie.poster)
			end
		end
end