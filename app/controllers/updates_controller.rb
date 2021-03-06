class UpdatesController < ApplicationController
	before_filter :authenticate_user!
	def index
		following_user_ids = get_following << current_user.id
		@tmdb = Tmdb.new
		@updates = Update.where(user_id: following_user_ids).where("created_at > ?", Time.at(params[:after].to_i + 1))
	end

	def create
		@update = current_user.updates.build(update_params)
		if @update.save
			ActivityWorker.perform_async("Update", @update.id, current_user.id)
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

	def more
		following_user_ids = get_following << current_user.id
		@tmdb = Tmdb.new
		@updates = Update.where(user_id: following_user_ids).where("created_at < ?", Time.at(params[:after].to_i - 1)).limit(5)
	end

	private
		def update_params
			params.require(:update).permit(:content)
		end
end
