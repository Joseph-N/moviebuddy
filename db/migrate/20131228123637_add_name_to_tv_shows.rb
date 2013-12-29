class AddNameToTvShows < ActiveRecord::Migration
  def change
    add_column :tv_shows, :name, :string
  end
end
