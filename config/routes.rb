# -*- encoding : utf-8 -*-
Simplegiveaways::Application.routes.draw do

  match '/canvas', to: 'canvas#index'

  resources :giveaways do
    resources :entries
    match :tab, :on => :collection
    get :start, :on => :member
    get :end, :on => :member
  end

  resources :facebook_pages do
    resources :giveaways do
      get :active, :on => :collection
      get :pending, :on => :collection
      get :completed, :on => :collection
    end
  end

  resources :users

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/logout', to: 'sessions#destroy'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'welcome#index'
end
