class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_filter :configure_permitted_parameters, if: :devise_controller?

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) << :name
		devise_parameter_sanitizer.for(:account_update) do |u|
			u.permit(:avator, :name, :email, :password, :password_confirmation)
		end
	end

  	def user_movie_genres(user)
		genres = []
		user.movies.each {|x| genres << x.genres }
		genres.flatten.uniq
	end

	def youtubeVideo(video_id)
		url = "http://www.youtube.com/oembed?url=http://youtube.com/watch?v=#{video_id}&format=json"
        begin
        	video = JSON.parse(RestClient.get url)
        	video["html"]
        rescue => e
        	"<div style='height: 30px;'>We did not find a trailer on youtube for this movie ;-)</div>"
        end
	end

	def get_following
		ids = []
		current_user.all_following.each{|x| ids << x.id }
		ids
	end
end
