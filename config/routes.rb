# -*- encoding : utf-8 -*-
Simplegiveaways::Application.routes.draw do

  match '/canvas', to: 'canvas#index'

  resources :giveaways do
    resources :entries
    match :tab, to: :collection
    get :manual_start, :on => :member
    get :manual_end, :on => :member
  end

  resources :facebook_pages do
    resources :giveaways
  end

  resources :users

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/logout', to: 'sessions#destroy'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'welcome#index'
end
