class UsersController < ApplicationController
	def index
		@users = User.where('id != ?', current_user.id)
	end

	def show
		@user = User.friendly.find(params[:id])
		@recent_movies = @user.movies.first(5)
		@tmdb = Tmdb.new
		@activities = PublicActivity::Activity.order('created_at desc').where(owner_id: @user.id, owner_type: "User").limit(5)
	end

	def edit
		@user = current_user
	end

	def update_password
	    @user = User.find(current_user.id)
	    if @user.update_with_password(user_params)
	      # Sign in the user by passing validation in case his password changed
	      flash[:notice] = "Successfully updated password"
	      sign_in @user, :bypass => true
	      redirect_to root_path
	    else
	      render "edit"
	    end
  	end

	def movies
		@user = User.friendly.find(params[:id])
		@genres = user_movie_genres(@user)
		if current_user == @user
			redirect_to movies_path
		else
			@movies = @user.movies
			@tmdb = Tmdb.new
		end
	end

	def following
		@user = User.friendly.find(params[:id])
		@following = @user.all_following
	end

	def followers
		@user = User.friendly.find(params[:id])
		@followers = @user.followers
	end

	def follow
		@user = User.friendly.find(params[:id])
		url = request.referer
		if current_user.follow(@user)
			ActivityWorker.perform_async("User", @user.id, current_user.id, { key: "user.follow", action: "follow"} )

			flash[:notice] = "successfully followed #{@user.name}"
			respond_to do |format|
				format.html { redirect_to url }
				format.js
			end
		end
	end

	def unfollow
		@user = User.friendly.find(params[:id])
		url = request.referer
		if current_user.stop_following(@user)
			#ActivityWorker.perform_async("User", @user.id, current_user.id, key = "user.unfollow", action = "unfollow")

			flash[:notice] = "successfully unfollowed #{@user.name}"
			respond_to do |format|
				format.html { redirect_to url}
				format.js
			end
		end
	end

	def activity
		@activity_id = params[:activity_id]
		@user = User.friendly.find(params[:id])
		@tmdb = Tmdb.new
		@activities = PublicActivity::Activity.where("owner_id = ? and owner_type = ? and id < ?", @user.id, "User",@activity_id).order('created_at desc').limit(2)
		respond_to do |format|
			format.js
		end
	end

	private

	def user_params
		params.required(:user).permit(:password, :password_confirmation, :current_password)
	end
end