class Movie < ActiveRecord::Base
	include PublicActivity::Common

	extend FriendlyId
  	friendly_id :title, use: :slugged

	acts_as_voteable

	belongs_to :user
	has_many :comments, dependent: :destroy

	validates_presence_of :user_id, :if => [:not_popular?, :upcoming?, :highest_rated?]

	def not_popular?
		self.popular == false
	end

	def upcoming?
		self.upcoming == false
	end

	def highest_rated?
		self.highest_rated == false
	end
end
