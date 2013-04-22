Rails.application.routes.draw do

  devise_for :admin_users, Cardboard::Devise.config

  resources :pianos

  namespace :cardboard do
    get "test", to: "test#index"
  end

  mount Cardboard::Engine => "/admin"




  root :to => "main#index"
end
