class Movie < ActiveRecord::Base
	include PublicActivity::Common

	acts_as_voteable

	belongs_to :user
	has_many :comments, dependent: :destroy

	validates_presence_of :user_id, :if => :not_popular?

	def not_popular?
		self.popular == false
	end
end
