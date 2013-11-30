ActiveAdmin.register Update do
  scope :all, :default => true
  scope :from_movies

  
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
   permitted = Update.columns.map { |c| c.name }
  end


  index do
    selectable_column
    column :id
    column :user
    column :content
    column :created_at  
    column "Movie Id", :movie
    default_actions
  end

  show :title => 'Update' do
    attributes_table :id, :content, :created_at, :movie, :user_id
    
  end

  filter :user
  filter :content
  filter :created_at


end
