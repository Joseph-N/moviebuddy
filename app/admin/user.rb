ActiveAdmin.register User do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  permit_params do
   permitted = User.columns.map { |c| c.name }
   permitted.push(:avator)
  end

  controller do
    def find_resource
      scoped_collection.where(slug: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :id
    column :name
    column :email    
    column "Last Signed In", :last_sign_in_at
    column "Signin Count",:sign_in_count
    column :provider
    column "Avator", :avator_file_name do |user|
      image_tag user.avator.url(:thumb)
    end
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Edit User" do
      f.input :name
      f.input :email
      f.input :avator, as: :file, :hint => f.template.image_tag(f.object.avator.url(:thumb))
      f.input :provider
      f.input :uid
      f.input :slug
      f.input :sign_in_count
      f.input :current_sign_in_ip
    end
    f.actions
  end

  filter :name
  filter :email
  filter :created_at
  filter :movies

  
  
end
