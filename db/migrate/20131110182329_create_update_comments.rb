class CreateUpdateComments < ActiveRecord::Migration
  def change
    create_table :update_comments do |t|
      t.text :content
      t.references :update, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
