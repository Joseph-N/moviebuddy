class User < ActiveRecord::Base
	include PublicActivity::Common

	extend FriendlyId
  	friendly_id :name, use: :slugged

	# Try building a slug based on the following fields in
	# increasing order of specificity.
	def slug_candidates
	[
	  :name,
	  [:id, :name]
	]
	end
	
	acts_as_voter 
	acts_as_followable
	acts_as_follower

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable, :omniauthable

	has_many :authentications, dependent: :destroy	
	has_many :movies, dependent: :destroy
	has_many :comments, through: :movies
	has_many :updates, dependent: :destroy
	has_many :comments, through: :updates	
	has_many :tv_shows, dependent: :destroy

	has_attached_file :avator, :styles => { :small => "32x32#", :thumb => "64x64#", :profile => "290x290#", :medium => "210x180#" },
		:url => "/assets/users/:id/:style/:basename.:extension",
	  	:path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
	  	:default_url => ':style_default.png'

	validates_presence_of :name
	validates_attachment_size :avator, :less_than => 5.megabytes
	validates_attachment_content_type :avator, :content_type => ['image/jpeg', 'image/png','image/jpg']


	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
		
		if signed_in_resource == nil
			authentication = Authentication.where(:provider => auth.provider, :uid => auth.uid).first
			user = authentication.user unless authentication.nil?
			unless user.nil?
				user.authentications.find_by_uid(auth.uid).update_attributes(provider:auth.provider,
	                uid:auth.uid,
	                token: auth.credentials.token,
	                )
			  	return user
			else
				unless  Authentication.where(:email => auth.info.email).first.nil?
					registered_user = Authentication.where(:email => auth.info.email).first.user
				else
					registered_user = User.where(:email => auth.info.email).first
				end

				if registered_user
					return registered_user
				else
					user = User.create(name:auth.extra.raw_info.name,
					    email:auth.info.email,
					    avator: URI.parse(auth.info.image),
					    password: Devise.friendly_token[0,20],
					    )
					user.authentications.create(username:auth.extra.raw_info.name,
						provider:auth.provider,
					    uid:auth.uid,
					    token: auth.credentials.token,	
					    social_url: auth.extra.raw_info.link			    
					    )
					return user
				end
			   
			end
		else
			signed_in_resource.authentications.create(username:auth.extra.raw_info.name,
					 provider:auth.provider,
				    uid:auth.uid,
				    token: auth.credentials.token,
				    email:auth.info.email,
				    social_url: auth.extra.raw_info.link
				    )
		    return signed_in_resource		
		end
	end

	def self.find_for_twitter_oauth(auth, signed_in_resource=nil) 
		if signed_in_resource == nil
			authentication = Authentication.where(:provider => auth.provider, :uid => auth.uid).first
			user = authentication.user unless authentication.nil?
			unless user.nil?
	    		return user
	  		else
	  			unless Authentication.where(:email => auth.info.nickname + "@twitter.com").first.nil?
	  				registered_user = Authentication.where(:email => auth.info.nickname + "@twitter.com").first.user
	  			else
	    			registered_user = User.where(:email => auth.info.nickname + "@twitter.com").first
	    		end

	    		if registered_user
	    	  		return registered_user
			    else
			    	user = User.create(name:auth.info.name,
			        	email:auth.info.nickname + "@twitter.com",	        
			        	avator: URI.parse(auth.info.image),
			        	password: Devise.friendly_token[0,20],
			      	)
			      	user.authentications.create(username:auth.info.nickname  ,
			      		provider:auth.provider,
			        	uid:auth.uid,
			        	token: auth.credentials.token,
			        	social_url: auth.info.urls.Twitter,
			        )
			      	return user
			    end
			end	
		else
			signed_in_resource.authentications.create(username:auth.info.nickname  ,
						provider:auth.provider,
			        	uid:auth.uid,
			        	token: auth.credentials.token,
			        	email:auth.info.nickname + "@twitter.com",
			        	social_url: auth.info.urls.Twitter,
			        	)
			return signed_in_resource
		end
	end

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
		data = access_token.info
		if signed_in_resource == nil
			authentication = Authentication.where(:provider => access_token.provider, :uid => access_token.uid).first
			user = authentication.user unless authentication.nil?
			unless user.nil?
				return user
			else
				unless Authentication.where(:email => access_token.info.email).first.nil?
					registered_user = Authentication.where(:email => access_token.info.email).first.user
				else
					registered_user = User.where(:email => access_token.info.email).first 
				end

				if registered_user
					return registered_user
				else
					user = User.create(name: data["name"],					
						email: data["email"],					
						avator: URI.parse(data["image"]),
						password: Devise.friendly_token[0,20],
					)
					user.authentications.create(username: data["name"],	
						provider:access_token.provider,
				        uid: access_token.uid ,
				        token: access_token.credentials.token,	
				        social_url: access_token.extra.raw_info.link,			        
				        )
					return user
				end
	    	end
	    else
	    	signed_in_resource.authentications.create(username: data["name"],	
	    			provider:access_token.provider,
	    	        uid: access_token.uid ,
	    	        token: access_token.credentials.token,
	    	        email: data["email"],
	    	        social_url: access_token.extra.raw_info.link,	
	    	        )
	    	return signed_in_resource			
		end
	end

	def self.search(query)
		conditions = <<-EOS
					    	to_tsvector('english', name) @@ to_tsquery('english', ?)
					  	EOS
	  	where(conditions, query + ':*')
	end

	def facebook
		token = self.authentications.find_by provider: "facebook".token
		Koala::Facebook::API.new(token)
	end

	def granted_permission?
		facebook.get_connections("me","permissions")[0]['publish_stream'].to_i  == 1 ? true : false 
	end

	def connected_facebook?
		self.authentications.where(provider: "facebook").first.present?
	end

	private
	def conditions

	end

end
