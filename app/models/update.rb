class Update < ActiveRecord::Base
	include PublicActivity::Common
	
	acts_as_voteable
	
	belongs_to :user
	has_many :update_comments

	validates_presence_of :user_id
	validates_presence_of :content, :if => :not_from_movie?

	default_scope { order('updates.created_at DESC') }

	def not_from_movie?
		self.movie.equal?(0) 
	end
end
