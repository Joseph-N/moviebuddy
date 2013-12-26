class RenameTableComments < ActiveRecord::Migration
  def change
  	rename_table :comments, :reviews
  	rename_table :update_comments, :comments
  end
end
