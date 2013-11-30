ActiveAdmin.register Comment do

  permit_params do
   permitted = Comment.columns.map { |c| c.name }
  end

  index do
    selectable_column
    column :id
    column :user
    column "Comment", :body 
    column :movie      
    column :created_at
    default_actions
  end

  filter :movie
  filter :user
  filter :body
  filter :created_at
  
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
  
end
