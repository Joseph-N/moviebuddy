class AddBackdropToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :backdrop, :string
  end
end
