class Movie < ActiveRecord::Base
	include PublicActivity::Common
  	
  	scope :popular, -> { where(:popular => true) }
  	scope :upcoming, -> { where(:upcoming => true) }
  	scope :highest_rated, -> { where(:highest_rated => true) }

  	default_scope -> { order('created_at desc') }

	extend FriendlyId
  	friendly_id :slug_name, use: :slugged

	# custom method for friendly id
	def slug_name
		"#{rand(36**5).to_s(36)}-#{title}"
	end

  	before_save :check_genres
	acts_as_voteable

	belongs_to :user
	has_many :reviews, dependent: :destroy

	validates_presence_of :user_id, :unless => [:not_popular?, :upcoming?, :highest_rated?]

	def not_popular?
		self.popular == true
	end

	def upcoming?
		self.upcoming == true
	end

	def highest_rated?
		self.highest_rated == true
	end
	
	private
	def check_genres
		if self.genres.nil?
			self.genres = ["Unknown"]
		end
	end
end
