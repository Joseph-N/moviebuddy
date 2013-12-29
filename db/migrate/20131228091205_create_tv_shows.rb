class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
      t.integer :tmdbid
      t.references :user, index: true

      t.timestamps
    end
  end
end
