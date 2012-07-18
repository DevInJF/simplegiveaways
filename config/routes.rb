# -*- encoding : utf-8 -*-
Simplegiveaways::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  match '/canvas', to: 'canvas#index'
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

  get '/facebook_pages/:facebook_page_id/giveaways/:id/reauth', to: 'giveaways#update',
                                                                as: 'reauth'

  resources :users, only: []

  get '/dashboard', to: 'users#show', as: 'dashboard'

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/logout', to: 'sessions#destroy'

  root to: 'welcome#index'
end