class Update < ActiveRecord::Base
	include PublicActivity::Common
	
	acts_as_voteable
	
	belongs_to :user
	has_many :update_comments

	validates_presence_of :user_id, :content

	default_scope { order('updates.created_at DESC') }
end
