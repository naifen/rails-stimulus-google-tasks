# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'

  resources :users, only: [:show, :edit, :update]
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :google_tasks, only: [:index, :create, :update, :destroy]
  post '/google_tasks/generate_url', to: 'google_tasks#generate_url',
        as: :google_tasks_generate_url
  post '/google_tasks/authorize', to: 'google_tasks#authorize',
        as: :google_tasks_authorize

  get '/login', to: 'user_sessions#new', as: :login
  delete '/logout', to: 'user_sessions#destroy', as: :logout
  get '/signup', to: 'registration#new', as: :signup
  post '/signup', to: 'registration#create', as: :create_signup

  get '/about', to: 'pages#about'
end
