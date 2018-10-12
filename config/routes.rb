# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'

  resources :users

  resources :user_sessions, only: [:new, :create, :destroy]

  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in

  get '/about', to: 'pages#about'
end
