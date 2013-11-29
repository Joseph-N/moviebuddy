ActiveAdmin.register UpdateComment do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  permit_params do
   permitted = UpdateComment.columns.map { |c| c.name }
  end

  index do
    selectable_column
    column :id
    column :content
    column "Update ID", :update
    column :created_at  
    default_actions
  end

  filter :update, :label => "Update ID"
  filter :user
  filter :content
  filter :created_at
  
end
