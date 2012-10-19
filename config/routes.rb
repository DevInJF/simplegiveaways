Sg::Application.routes.draw do

  match '/leaf', to: 'leaf#index', as: 'leaf'

  root to: 'home#index'

  resources :users, only: [:index, :show, :edit, :update]

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/signin', to: 'sessions#new', as: :signin
  match '/signout', to: 'sessions#destroy', as: :signout
  match '/auth/failure', to: 'sessions#failure'
end
