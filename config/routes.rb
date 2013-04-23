Cardboard::Engine.routes.draw do

  get "account", to: "users#edit", as: "user"
  get "pages/:id", to: "pages#edit"
  resources :pages


  # scope "/super_admin" do
  #   get "/", to: "super_admin#index", as: "super_admin"
  # end
  get "/yoda", to: "super_user#index"

  get "/", to: "dashboard#index", as: "dashboard"
  #Don't put a root path here, use "/" instead...
end



Rails.application.routes.draw do
  scope  :constraints => { :format => 'html' } do #:format => true,
    get "*id", to: "cardboard/pages#show", as: :page
  end


  root :to => "cardboard/pages#index"
end

