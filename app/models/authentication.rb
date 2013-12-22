class Authentication < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :provider, :uid, :token
end
