class Review < ActiveRecord::Base
	include PublicActivity::Common

	belongs_to :movie
	belongs_to :user
	validates_presence_of :movie_id, :user_id, :body
end
