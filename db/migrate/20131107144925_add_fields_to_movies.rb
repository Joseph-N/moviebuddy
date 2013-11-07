class AddFieldsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :budget, :int
    add_column :movies, :homepage, :string
    add_column :movies, :release_date, :date
  end
end
