class User < ActiveRecord::Base
	include PublicActivity::Common

	extend FriendlyId
  	friendly_id :name, use: :slugged
	
	acts_as_voter 
	acts_as_followable
	acts_as_follower

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable, :omniauthable

	
	has_many :movies, dependent: :destroy
	has_many :comments, through: :movies
	has_many :updates, dependent: :destroy
	has_many :update_comments, through: :updates	

	has_attached_file :avator, :styles => { :thumb => "64x64#", :profile => "290x290#", :medium => "210x180#" },
		:url => "/assets/users/:id/:style/:basename.:extension",
	  	:path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
	  	:default_url => ':style_default.png'

	validates_presence_of :name
	validates_attachment_size :avator, :less_than => 5.megabytes
	validates_attachment_content_type :avator, :content_type => ['image/jpeg', 'image/png','image/jpg']


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
		                        avator: URI.parse(auth.info.image),
		                        password: 'password',
		                      )
		  end
		   
		end
	end

	def self.find_for_twitter_oauth(auth, signed_in_resource=nil) 
	  user = User.where(:provider => auth.provider, :uid => auth.uid).first
	  if user
	    return user
	  else
	    registered_user = User.where(:email => auth.info.nickname + "@twitter.com").first
	    if registered_user
	      return registered_user
	    else
	      user = User.create(name:auth.info.name,
	        provider:auth.provider,
	        uid:auth.uid,
	        email:auth.info.nickname + "@twitter.com",
	        avator: URI.parse(auth.info.image),
	        password:'password',
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
					avator: URI.parse(data["image"]),
					password: 'password',
				)
			end
    	end
	end
end
