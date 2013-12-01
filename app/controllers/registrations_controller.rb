class RegistrationsController < Devise::RegistrationsController

  def new
    @recent_movies = Movie.where('popular = ? and upcoming = ? and highest_rated = ?', false, false, false).last(5)
    @random_movie = Movie.where(popular: true).sample
    @tmdb = Tmdb.new
    @image = @tmdb.imageUrl('backdrop','original', @random_movie.backdrop) if @random_movie
    super
  end

  def create
    super
    MailerWorker.perform_async(@user.id, "registration") unless @user.invalid?
  end

  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
      params[:user][:password].present?
  end

end 