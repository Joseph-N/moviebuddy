class CommentsController < ApplicationController
	def create
		@movie = Movie.find(params[:movie_id])
		@comment = @movie.comments.build(comment_params)
		@comment.user_id = current_user.id
		if @comment.save
			respond_to do |format|
				format.html { redirect_to movie_path(@movie) }
				format.js
			end
		else
			render 'movies/show'
		end
	end

	private
		def comment_params
			params.require(:comment).permit(:body)
		end
end
