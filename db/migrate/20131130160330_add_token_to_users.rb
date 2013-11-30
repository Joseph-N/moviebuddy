class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :text
  end
end
