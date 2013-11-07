class MoviesController < ApplicationController
	before_filter :authenticate_user!
	before_action :init_tmdb, only: [:index, :show, :fetch]

	def index
		if params[:q]
			raw_movies = @tmdb.searchMovie(params[:q])
			@movies = raw_movies["results"].delete_if { |x| x.nil? }
		else
			@movies = current_user.movies
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
		elsif params[:vote] == 'down'
			if current_user.voted_on?(@movie)
        		current_user.vote_exclusively_against(@movie)
        	else
				current_user.vote_against(@movie)
			end
		end
		respond_to do |format|
			format.html { redirect_to movie_path(@movie) }
			format.js
		end
	end

	private
		def init_tmdb
			@tmdb = Tmdb.new
		end

		def movie_params
			params.require(:movie).permit(:title, :overview, :poster, :comment, :youtube_id, :tag_line, :release_date, :homepage,  :backdrop, :budget, genres: [])
		end

		def youtubeVideo(video_id)
			url = "http://www.youtube.com/oembed?url=http://youtube.com/watch?v=#{video_id}&format=json"
	        begin
	        	video = JSON.parse(RestClient.get url)
	        	video["html"]
	        rescue => e
	        	"<div style='height: 30px;'>We did not find a trailer on youtube for this movie ;-)</div>"
	        end
    	end
end