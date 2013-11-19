class AddUpcomingHighestRatedColumnsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :upcoming, :boolean, :default => false
    add_column :movies, :highest_rated, :boolean, :default => false
  end
end
