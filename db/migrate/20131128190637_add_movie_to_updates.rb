class AddMovieToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :movie, :integer, :default => 0
  end
end
