class Comment < ActiveRecord::Base
	include PublicActivity::Common
	
	belongs_to :update
	belongs_to :user

	validates_presence_of :update_id, :user_id, :content
end
