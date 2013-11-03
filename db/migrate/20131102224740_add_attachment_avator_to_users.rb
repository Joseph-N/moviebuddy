class AddAttachmentAvatorToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :avator
    end
  end

  def self.down
    drop_attached_file :users, :avator
  end
end
