class HomeController < ApplicationController
	before_filter :authenticate_user!
	
	def index
		@user = current_user
		@movies = @user.movies
	end
end
