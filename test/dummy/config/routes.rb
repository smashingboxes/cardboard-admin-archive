Rails.application.routes.draw do

  devise_for :admin_users, Cardboard::Devise.config

  resources :pianos

  mount Cardboard::Engine => "/"




  root :to => "main#index"
end
