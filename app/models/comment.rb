class Comment < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user
  validates_presence_of :movie_id, :user_id, :body
end
