class AddTagLineToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :tag_line, :string
  end
end
