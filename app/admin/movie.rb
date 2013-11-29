ActiveAdmin.register Movie do
  scope :all, :default => true
  scope :popular
  scope :upcoming
  scope :highest_rated

  config.per_page = 10

  controller do
    def find_resource
      scoped_collection.where(slug: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :id
    column "Poster", :poster do |movie|
      image_tag "http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w92/#{movie.poster}"
    end
    column :title
    column :overview
    column :budget do |movie|
      number_to_currency movie.budget
    end

    default_actions

  end

  show do
    attributes_table :id, :title, :tag_line, :overview, :user, :comment, :youtube_identifier, 
                     :budget, :release_date, :homepage
  end

  sidebar :movie_comments do

  end

  filter :title
  filter :user
  filter :genres
  filter :budget

  permit_params do
   permitted = Movie.columns.map { |c| c.name }
  end

  
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
