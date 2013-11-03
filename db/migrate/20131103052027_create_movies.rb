class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :overview
      t.string :poster
      t.string :genres, array: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
