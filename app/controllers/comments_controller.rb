class CommentsController < ApplicationController
	def index
		@movie = Movie.friendly.find(params[:movie_id])
		@comments = Comment.where("movie_id = ? and created_at > ?", @movie.id, Time.at(params[:after].to_i + 1))
    end

	def create
		@movie = Movie.friendly.find(params[:movie_id])
		@comment = @movie.comments.build(comment_params)
		@comment.user_id = current_user.id
		if @comment.save
			ActivityWorker.perform_async("Comment", @comment.id, current_user.id)	
			ShareWorker.perform_async("facebook", "Comment", current_user.id, @comment.id, { activity: "movie.comment", url: movie_url(@movie)})
			MailerWorker.perform_async(@movie.user.id, "movieComment", { actor_id: current_user.id, movie_id: @movie.id, comment_id: @comment.id })

			respond_to do |format|
				format.html { redirect_to movie_path(@movie) }
				format.js
			end
		else
			@movie = Movie.friendly.find(params[:movie_id])
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
