class AddSocialUrlToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :social_url, :string
  end
end
