class CommentsController < ApplicationController
	def index
		@comments = Comment.where("movie_id = ? and created_at > ?", params[:movie_id], Time.at(params[:after].to_i + 1))
    end

	def create
		@movie = Movie.find(params[:movie_id])
		@comment = @movie.comments.build(comment_params)
		@comment.user_id = current_user.id
		if @comment.save
			@comment.create_activity :create, owner: current_user
			
			respond_to do |format|
				format.html { redirect_to movie_path(@movie) }
				format.js
			end
		else
			@movie = Movie.find(params[:movie_id])
			@tmdb = Tmdb.new
			@comments = @movie.comments
			@trailer = youtubeVideo(@movie.youtube_id)
			render 'movies/show'
		end
	end

	private
		def comment_params
			params.require(:comment).permit(:body)
		end
end
