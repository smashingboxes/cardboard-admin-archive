Cardboard::Engine.routes.draw do
#Rails.application.routes.draw do

  devise_for :users, :class_name => "Cardboard::User", :module => :devise


  scope "/admin" do
    get "/", to: "admin#dashboard", as: "dashboard"
    get "account", to: "users#edit", as: "user_account"
    resources :users
    resources :pages
  end

  # scope "/super_admin" do
  #   get "/", to: "super_admin#index", as: "super_admin"
  # end
  
  get "*id", to: "pages#show", as: "public"
  
  root :to => "pages#index"
end

