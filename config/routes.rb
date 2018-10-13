# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'

  resources :users

  resources :user_sessions, only: [:new, :create, :destroy]

  delete '/logout', to: 'user_sessions#destroy', as: :logout
  get '/login', to: 'user_sessions#new', as: :login

  get '/about', to: 'pages#about'
end
