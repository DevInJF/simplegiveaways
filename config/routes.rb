# -*- encoding : utf-8 -*-
Simplegiveaways::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  match '/terms', to: 'welcome#terms'
  match '/privacy', to: 'welcome#privacy'
  match '/support', to: 'welcome#support'

  match '/canvas', to: 'canvas#index'
  match '/canvas/edit', to: 'canvas#edit'
  match '/giveaways/tab', to: 'giveaways#tab'

  resources :likes, only: [:create]

  resources :facebook_pages, only: [:show] do
    resources :giveaways do
      resources :entries, only: [:create, :update]

      get :export_entries, on: :member
      get :active, on: :collection
      get :pending, on: :collection
      get :completed, on: :collection

      match :start, on: :member
      get :end, on: :member
    end
  end

  resources :users, only: []
  match '/deauth/:provider', to: 'users#deauth'

  get '/dashboard', to: 'users#show', as: 'dashboard'

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/logout', to: 'sessions#destroy'

  root to: 'welcome#index'
end
