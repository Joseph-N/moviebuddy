class RemoveCommentFromMovies < ActiveRecord::Migration
  def change
  	remove_column :movies, :comment, :string
  end
end
