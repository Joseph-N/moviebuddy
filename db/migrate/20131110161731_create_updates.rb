class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
  end
end
