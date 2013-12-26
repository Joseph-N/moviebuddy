class CommentsController < ApplicationController
	before_filter :authenticate_user!
	def create
		@update = Update.find(params[:update_id])
		@comment = @update.comments.build(update_comment_params)
		@comment.user_id = current_user.id
		if @comment.save
			ActivityWorker.perform_async("Comment", @comment.id, current_user.id)
			MailerWorker.perform_async(@update.user.id, "Comment", { actor_id: current_user.id, update_id: @update.id, comment_id: @comment.id })

			respond_to do |format|
				format.html { redirect_to root_path }
				format.js
			end
		else
			render 'home/index'
		end
	end

	private
		def update_comment_params
			params.require(:comment).permit(:content)
		end
end
