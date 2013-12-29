class AddPosterToTvShows < ActiveRecord::Migration
  def change
    add_column :tv_shows, :poster, :string
  end
end
