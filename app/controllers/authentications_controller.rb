class AuthenticationsController < ApplicationController
	def destroy
		@provider = params[:auth]
		@authentication = current_user.authentications.where("provider = ?", @provider).first
		if @authentication.destroy
			gflash :success => "Disconnected from #{@provider}"
			redirect_to user_sharing_path
		end
	end
end
