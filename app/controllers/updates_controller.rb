class UpdatesController < ApplicationController
	def create
		@update = current_user.updates.build(update_params)
		if @update.save
			respond_to do |format|
				format.html { redirect_to root_path }
				format.js
			end
		else
			render 'home/index'
		end
	end

	def vote
		@update = Update.find(params[:id])
		if params[:vote] == 'up'
			current_user.vote_exclusively_for(@update)
		elsif params[:vote] == 'down'
        	current_user.vote_exclusively_against(@update)
		end
		
		respond_to do |format|
			format.html { redirect_to root_path }
			format.js
		end
	end

	private
		def update_params
			params.require(:update).permit(:content)
		end
end
