Rails.application.routes.draw do

  resources :pianos


  mount Cardboard::Engine => "/"

  root :to => "main#index"
end
