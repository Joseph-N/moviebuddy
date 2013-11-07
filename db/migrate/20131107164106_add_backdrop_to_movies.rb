class AddBackdropToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :backdrop, :string
  end
end
