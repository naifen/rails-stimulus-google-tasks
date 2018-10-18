# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'

  resources :users

  resources :user_sessions, only: [:new, :create, :destroy]

  get '/login', to: 'user_sessions#new', as: :login
  delete '/logout', to: 'user_sessions#destroy', as: :logout
  get '/signup', to: 'registration#new', as: :signup
  post '/signup', to: 'registration#create', as: :create_signup

  get '/about', to: 'pages#about'
end
