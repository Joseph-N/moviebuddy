require 'sidekiq/web'
MovieBuddy::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  authenticated :user do
    root "home#index"
  end

  unauthenticated :user do
    devise_scope :user do
      get "/" => "sessions#new"
    end
  end

  authenticate :admin_user do
    mount Sidekiq::Web => '/admin/sidekiq'    
  end
  
  devise_for :users, :controllers => {
                        :omniauth_callbacks => "users/omniauth_callbacks",
                        :sessions => "sessions",
                        :registrations => "registrations"
                      }

  resources :movies do
    resources :reviews
    member do
      get 'vote'
    end
  end

  resources :tv_shows

  resources :updates, :only => [:create, :index] do
    resources :comments, :only => [:create]
    member do
      get 'vote'
    end
  end

  get 'users' => 'users#index', as: :all_users
  get 'users/:id' => 'users#show', as: :user_show
  get 'users/:id/movies' => 'users#movies', as: :user_movies
  get 'users/:id/following' => 'users#following', as: :user_follows
  get 'users/:id/followers' => 'users#followers', as: :user_followers
  get 'users/:id/activity' => 'users#activity'
  get 'password/edit' => 'users#edit', as: :password_edit
  patch 'password/edit' => 'users#update_password'
  get 'settings/sharing' => 'users#sharing', as: :user_sharing
  delete 'settings/sharing' => 'authentications#destroy', as: :delete_auth
  get 'updates/more' => 'updates#more'

  get '/follow' => 'users#follow', as: :user_follow
  get '/unfollow' => 'users#unfollow', as: :user_unfollow


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
