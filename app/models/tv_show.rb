class TvShow < ActiveRecord::Base
	include PublicActivity::Common

	belongs_to :user

  	validates_presence_of :user_id, :name, :tmdbid

	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	# Try building a slug based on the following fields in
	# increasing order of specificity.
	def slug_candidates
	[
	  :name,
	  [:id, :name]
	]
	end
end
