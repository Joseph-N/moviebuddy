class Movie < ActiveRecord::Base
	acts_as_voteable
	
	belongs_to :user

	validates_presence_of :user_id
end
