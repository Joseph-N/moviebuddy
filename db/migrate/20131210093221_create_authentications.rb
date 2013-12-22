class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.text :token
      t.references :user, index: true

      t.timestamps
    end
  end
end
