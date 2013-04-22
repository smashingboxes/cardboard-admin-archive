Cardboard::Engine.routes.draw do

  # devise_for :users, :class_name => "Cardboard::User", :module => :devise


  get "/", to: "dashboard#index", as: "dashboard"
  get "account", to: "users#edit", as: "user"
  # resources :users
  resources :pages


  # scope "/super_admin" do
  #   get "/", to: "super_admin#index", as: "super_admin"
  # end

  root :to => "cardboard/pages#index"
end

Rails.application.routes.draw do
  scope  :constraints => { :format => 'html' } do #:format => true,
    get "*id", to: "cardboard/pages#show", as: :page
  end
end

