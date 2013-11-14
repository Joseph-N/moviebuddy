class Movie < ActiveRecord::Base
	acts_as_voteable

	belongs_to :user
	has_many :comments, dependent: :destroy

	validates_presence_of :user_id
end
