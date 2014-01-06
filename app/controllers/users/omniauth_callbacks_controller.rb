class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
 
    if @user.persisted?
      if current_user
        gflash :success => {:title => "Great!", :value => "Successfully connected Facebook"}
        redirect_to request.referer
      else
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      end
      gflash :success => "Successfully Authenticated from Facebook" if is_navigational_format?

    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    auth = env["omniauth.auth"]
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"],current_user)
    if @user.persisted?
      if current_user
        gflash :success => {:title => "Great!", :value => "Successfully connected Twitter"}
        redirect_to request.referer
      else
        gflash :success => "Successfully Authenticated from Twitter"
        sign_in_and_redirect @user, :event => :authentication
      end
    else
      session["devise.twitter_uid"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2     
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
 
    if @user.persisted?
      if current_user
        gflash :success => {:title => "Great!", :value => "Successfully connected Google"}
        redirect_to request.referer
      else
        gflash :success => "Successfully Authenticated from Google"
        sign_in_and_redirect @user, :event => :authentication
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end