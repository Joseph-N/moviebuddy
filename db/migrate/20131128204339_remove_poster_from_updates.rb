class RemovePosterFromUpdates < ActiveRecord::Migration
  def change
    remove_column :updates, :poster, :string
  end
end
