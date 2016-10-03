Rails.application.routes.draw do

  # admin
  namespace :admin do
    resource :application_settings, path: 'settings', only: [:show, :update]
    get 'users', to: 'dashboard#users'
    get 'projects', to: 'dashboard#projects'
    root to: 'dashboard#index'
  end

  # authentication
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/profile'
  }

  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
    patch 'users/:id/toggle_admin', to: 'users/profile#toggle_admin', as: :toggle_admin
    get 'users/:id', to: 'users/profile#show', as: :user
    get 'users/:id/edit', to: 'users/profile#edit', as: :edit_user
    get 'users/:id/activity', to: 'users/profile#activity', as: :user_activity
    get 'users/:id/projects', to: 'users/profile#projects', as: :user_projects
    patch 'users/:id', to: 'users/profile#update'
    get 'users/auth/:provider/setup', to: 'users/omniauth_callbacks#setup'
  end

  # resources
  resources :projects, except: :new do
    collection do
      get 'setup'
      post 'webhook'
    end
    member do
      get 'commits'
      get 'issues'
      get 'contributors'
    end
  end

  # root
  get '/pricing', to: 'root#pricing'
  get '/crash', to: 'root#crash'
  root to: 'root#index'
end
