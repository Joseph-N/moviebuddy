class HomeController < ApplicationController
	before_filter :authenticate_user!

	def index
		@users = User.first(3)
		@tmdb = Tmdb.new
		@update = Update.new
		following_user_ids = get_following << current_user.id
		@updates = Update.where(user_id: following_user_ids)
		@popular_movies = Movie.where(popular: true).sample(3)
		@upcoming_movies = Movie.where(upcoming: true).sample(3)
		@highest_rated = Movie.where(highest_rated: true).sample(3)
		# @users = User.where.not(id: current_user.id)
	end

end
