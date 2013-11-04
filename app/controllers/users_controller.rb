class UsersController < ApplicationController
	def index
	end

	def show
		@user = User.find(params[:id])
	end

	def movies
		@user = User.find(params[:id])
		@movies = @user.movies
	end

	def following
		@following = User.find(params[:id]).all_following
	end

	def followers
		@followers = User.find(params[:id]).followers
	end

	def follow
		@user = User.find(params[:id])
		if current_user.follow(@user)
			flash[:notice] = "successfully followed #{@user.name}"
			redirect_to root_path
		end
	end

	def unfollow
		@user = User.find(params[:id])
		if current_user.stop_following(@user)
			flash[:notice] = "successfully unfollowed #{@user.name}"
			redirect_to root_path
		end
	end
end