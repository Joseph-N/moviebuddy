class User < ActiveRecord::Base
	acts_as_voter 

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable, :omniauthable

	
	has_many :movies	

	has_attached_file :avator, :styles => { :thumb => "150x150#" },
		:url => "/assets/users/:id/:style/:basename.:extension",
	  	:path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"

	validates_presence_of :name
	validates_attachment_size :avator, :less_than => 5.megabytes
	validates_attachment_content_type :avator, :content_type => ['image/jpeg', 'image/png']

	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
		user = User.where(:provider => auth.provider, :uid => auth.uid).first
		if user
		  return user
		else
		  registered_user = User.where(:email => auth.info.email).first
		  if registered_user
		    return registered_user
		  else
		    user = User.create(name:auth.extra.raw_info.name,
		                        provider:auth.provider,
		                        uid:auth.uid,
		                        email:auth.info.email,
		                        password:Devise.friendly_token[0,20],
		                      )
		  end
		   
		end
	end

	def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
 
	  user = User.where(:provider => auth.provider, :uid => auth.uid).first
	  if user
	    return user
	  else
	    registered_user = User.where(:email => auth.uid + "@twitter.com").first
	    if registered_user
	      return registered_user
	    else
	      user = User.create(name:auth.info.name,
	        provider:auth.provider,
	        uid:auth.uid,
	        email:auth.uid+"@twitter.com",
	        password:Devise.friendly_token[0,20],
	      )
	    end
	  end
	end

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
		data = access_token.info
		user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
		if user
			return user
		else
			registered_user = User.where(:email => access_token.info.email).first
			if registered_user
				return registered_user
			else
				user = User.create(name: data["name"],
					provider:access_token.provider,
					email: data["email"],
					uid: access_token.uid ,
					password: Devise.friendly_token[0,20],
				)
			end
    	end
	end
end
