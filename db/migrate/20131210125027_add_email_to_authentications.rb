class AddEmailToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :email, :string
  end
end
