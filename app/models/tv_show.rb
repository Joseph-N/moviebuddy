class TvShow < ActiveRecord::Base
	include PublicActivity::Common
	
	belongs_to :user

  	validates_presence_of :user_id, :name, :tmdbid

	extend FriendlyId
	friendly_id :name, use: :slugged
end
