Rails.application.routes.draw do

  # admin
  get 'admin/overview'
  get 'admin/users'
  get 'admin/projects'
  get 'admin/settings'

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
    patch 'users/:id', to: 'users/profile#update'
  end

  # resources
  resources :projects do
    get 'setup', on: :collection
    post 'webhook', on: :collection
  end

  # static
  get '/pricing', to: 'static#pricing'
  root to: 'static#index'
end
