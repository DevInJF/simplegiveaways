# -*- encoding : utf-8 -*-
Simplegiveaways::Application.routes.draw do

  require 'sidekiq/web'

  devise_for :admin_users, ActiveAdmin::Devise.config

  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  ActiveAdmin.routes(self)

  match '/terms', to: 'welcome#terms'
  match '/privacy', to: 'welcome#privacy'
  match '/support', to: 'welcome#support'

  match '/canvas', to: 'canvas#index'
  match '/canvas/edit', to: 'canvas#edit'
  match '/giveaways/tab', to: 'giveaways#tab'

  resources :likes, only: [:create]

  resources :facebook_pages, only: [:index, :show] do

    resources :giveaways do
      resources :entries, only: [:index, :create, :update]

      get :export_entries, on: :member
      get :active, on: :collection
      get :pending, on: :collection
      get :completed, on: :collection
      get :check_schedule, on: :collection
      get :clone, on: :member
      match :start, on: :member
      get :start_modal, on: :member
      get :end, on: :member
    end
  end

  match '/facebook_pages/:facebook_page_id/subscribe', to: 'subscriptions#create', as: 'facebook_page_subscribe'

  match '/facebook_pages/:facebook_page_id/subscription_plans', to: 'subscription_plans#index', as: 'facebook_page_subscription_plans'

  match '/users/:user_id/subscribe', to: 'subscriptions#create', as: 'user_subscribe'

  match '/users/:user_id/unsubscribe', to: 'subscriptions#destroy', as: 'user_unsubscribe'

  match '/users/:user_id/subscription_plans', to: 'subscription_plans#index', as: 'user_subscription_plans'

  resources :users

  match '/deauth/:provider', to: 'users#deauth'

  get '/dashboard', to: 'users#show', as: 'dashboard'

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/logout', to: 'sessions#destroy'

  match '/:giveaway_id', to: 'giveaways#enter', as: 'enter'

  root to: 'welcome#index'
end
