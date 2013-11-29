class RenameYoutubeId < ActiveRecord::Migration
  def change
  	rename_column :movies, :youtube_id, :youtube_identifier
  end
end
