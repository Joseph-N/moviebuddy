class AddCommentToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :comment, :text
  end
end
