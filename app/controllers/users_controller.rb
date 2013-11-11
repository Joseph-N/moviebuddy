class UsersController < ApplicationController
	def index
	end

	def show
		@user = User.find(params[:id])
		@recent_movies = @user.movies.first(5)
		@tmdb = Tmdb.new
	end

	def edit
		@user = current_user
	end

	def update_password
	    @user = User.find(current_user.id)
	    if @user.update_with_password(user_params)
	      # Sign in the user by passing validation in case his password changed
	      sign_in @user, :bypass => true
	      redirect_to root_path
	    else
	      render "edit"
	    end
  	end

	def movies
		@user = User.find(params[:id])
		@genres = user_movie_genres(@user)
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
		url = request.referer
		if current_user.follow(@user)
			flash[:notice] = "successfully followed #{@user.name}"
			redirect_to url
		end
	end

	def unfollow
		@user = User.find(params[:id])
		url = request.referer
		if current_user.stop_following(@user)
			flash[:notice] = "successfully unfollowed #{@user.name}"
			redirect_to url
		end
	end

	private

	def user_params
		params.required(:user).permit(:password, :password_confirmation)
	end
end