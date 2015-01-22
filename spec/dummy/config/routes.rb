Rails.application.routes.draw do
  devise_for :admin_users
  mount Cardboard::Engine => '/cardboard'

  resources :pianos
end
