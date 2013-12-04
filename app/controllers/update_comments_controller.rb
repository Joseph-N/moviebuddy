class UpdateCommentsController < ApplicationController
	before_filter :authenticate_user!
	def create
		@update = Update.find(params[:update_id])
		@update_comment = @update.update_comments.build(update_comment_params)
		@update_comment.user_id = current_user.id
		if @update_comment.save
			ActivityWorker.perform_async("UpdateComment", @update_comment.id, current_user.id)
			MailerWorker.perform_async(@update.user.id, "updateComment", { actor_id: current_user.id, update_id: @update.id, comment_id: @update_comment.id })

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
			params.require(:update_comment).permit(:content)
		end
end
