class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :updates, :backdrop, :poster
  end
end
