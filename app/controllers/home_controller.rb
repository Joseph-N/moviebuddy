class HomeController < ApplicationController
	before_filter :authenticate_user!

	def index
		@user = current_user
		@movies = @user.movies
		@users = User.where.not(id: current_user.id)
	end
end
