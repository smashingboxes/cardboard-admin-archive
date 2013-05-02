Rails.application.routes.draw do

  resources :beans


  resources :icescreams


  get "news", to: "cardboard/news_posts#index"

  devise_for :admin_users, Cardboard::Devise.config

  resources :pianos



  mount Cardboard::Engine => "/admin"



end
