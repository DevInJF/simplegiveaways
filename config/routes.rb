SGA::Application.routes.draw do

  # Giveaway
  resources :giveaways do
    resources :entries
    match :tab, :on => :collection
    get :app_request, :on => :collection
    get :manual_start, :on => :member
    get :manual_end, :on => :member
  end

  # FacebookPage / FacebookPage giveaways
  resources :facebook_pages do
    resources :giveaways
  end

  # User
  resources :users

  # User Authentication
  devise_for :users,
             :singular => :user,
             :controllers => {:registrations => 'registrations'}

  # 3rd Party User Authentication
  resources :authentications
  match '/auth/:provider/callback' => 'authentications#create'

  # AdminUser
  ActiveAdmin.routes(self)

  # AdminUser Authentication
  devise_for :admin_users, ActiveAdmin::Devise.config

  # Root
  root :to => 'welcome#index'
end
