class HomeController < ApplicationController
	before_filter :authenticate_user!

	def index
		@update = Update.new
		following_user_ids = get_following << current_user.id
		@updates = Update.where(user_id: following_user_ids)
		# @users = User.where.not(id: current_user.id)
	end

	private
		def get_following
			ids = []
			current_user.all_following.each{|x| ids << x.id }
			ids
		end
end
