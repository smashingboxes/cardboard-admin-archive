# Routes for admin interface
Cardboard::Engine.routes.draw do

  get "my_account", to: "my_account#edit"
  patch "my_account", to: "my_account#update"

  post "pages/sort", to: "pages#sort"
  resources :pages

  get "/yoda", to: "super_user#index"

  get "/settings", to: "settings#index"
  patch "/settings/update", to: "settings#update", as: "setting"

  post 'markdown', to: 'previews#create'

  get "/", to: "dashboard#index", as: "dashboard" #Don't put a root path here

  scope as: 'cardboard' do
    #generate routes for custom cardboard resources controllers
    Cardboard.resource_controllers.each do |controller|
      if controller.singular?
        # Singular controller names are non-standard in rails.  We must specify the
        # controller explicitly here to keep the name from
        # being pluralized in the route.
        resource controller.controller_name, controller: controller.controller_name
      else
        resources controller.controller_name
      end
    end
  end

end

# Routes for public pages
Cardboard::DynamicRouter.load
