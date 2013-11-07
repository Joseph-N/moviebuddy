class UsersController < ApplicationController
	def index
	end

	def show
		@user = User.find(params[:id])
		@recent_movies = @user.movies.last(5)
		@tmdb = Tmdb.new
	end

	def movies
		@user = User.find(params[:id])
		if current_user == @user
			redirect_to movies_path
		else
			@movies = @user.movies
			@tmdb = Tmdb.new
		end
	end

	def following
		@user = User.find(params[:id])
		@following = @user.all_following
	end

	def followers
		@user = User.find(params[:id])
		@followers = @user.followers
	end

	def follow
		@user = User.find(params[:id])
		if current_user.follow(@user)
			flash[:notice] = "successfully followed #{@user.name}"
			redirect_to user_show_path(@user)
		end
	end

	def unfollow
		@user = User.find(params[:id])
		if current_user.stop_following(@user)
			flash[:notice] = "successfully unfollowed #{@user.name}"
			redirect_to user_show_path(@user)
		end
	end
end