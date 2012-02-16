Simplegiveaways::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # Transaction
  resources :transactions

  # Canvas on facebook.com
  match "/canvas" => "canvas#index"

  # Giveaway
  resources :giveaways do
    resources :entries
    match :tab, :on => :collection
    get :manual_start, :on => :member
    get :manual_end, :on => :member
  end

  # FacebookPage / FacebookPage giveaways
  resources :facebook_pages do
    resources :giveaways
  end

  # User Authentication
  devise_for :users,
             :singular => :user,
             :controllers => {:registrations => "registrations"} do
    get "logout" => "devise/sessions#destroy"
  end

  # User
  resources :users

  # 3rd Party User Authentication
  resources :authentications
  match "/auth/:provider/callback" => "authentications#create"

  # Root
  root :to => "welcome#index"
end
