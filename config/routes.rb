Rails.application.routes.draw do
  # authentication
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # resources
  resources :projects

  # static
  get '/about', to: 'static#about'
  root to: 'static#index'
end
