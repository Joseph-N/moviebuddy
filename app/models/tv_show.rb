class TvShow < ActiveRecord::Base
	include PublicActivity::Common

	belongs_to :user

  	validates_presence_of :user_id, :name, :tmdbid

	extend FriendlyId
	friendly_id :slug_name, use: :slugged

	# custom method for friendly id
	def slug_name
		"#{rand(36**5).to_s(36)}-#{name}"
	end
end
