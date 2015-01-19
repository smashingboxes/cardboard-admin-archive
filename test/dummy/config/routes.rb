Rails.application.routes.draw do
  root "pianos#index"
  mount Cardboard::Engine => "/cardboard"
  resources :beans


  resources :icescreams


  get "news", to: "cardboard/news_posts#index"

  devise_for :admin_users

  resources :pianos

end
