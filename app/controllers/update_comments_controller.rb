class UpdateCommentsController < ApplicationController
	def create
		@update = Update.find(params[:update_id])
		@comment = @update.update_comments.build(update_comment_params)
		@comment.user_id = current_user.id
		if @comment.save
			respond_to do |format|
				format.html { redirect_to root_path }
				format.js
			end
		else
			render 'movies/show'
		end
	end

	private
		def update_comment_params
			params.require(:update_comment).permit(:content)
		end
end
