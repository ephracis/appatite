Rails.application.routes.draw do
  resources :projects
  get '/about', to: 'static#about'
  root to: 'static#index'
end
