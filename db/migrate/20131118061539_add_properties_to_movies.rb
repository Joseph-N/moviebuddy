class AddPropertiesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :tmdb_id, :integer
    add_column :movies, :popular, :boolean, :default => false
    add_index :movies, :popular
  end
end
