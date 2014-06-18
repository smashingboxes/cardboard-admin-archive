# Routes for admin interface
Cardboard::Engine.routes.draw do

  get "my_account", to: "my_account#edit"
  patch "my_account", to: "my_account#update"

  post "pages/sort", to: "pages#sort"
  resources :pages

  get "/yoda", to: "super_user#index"

  get "/settings", to: "settings#index"
  patch "/settings/update", to: "settings#update", as: "setting"

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

#legacy support
Rails.application.routes.named_routes.module.module_eval do
  def page_path(identifier, options = {})
    url = Cardboard::Page.where(identifier: identifier.to_s).first.try(:url)
    options.present? && url ? "#{url}?#{options.to_query}" : url
  end

  def page_url(identifier, options = {})
    return nil unless url = page_path(identifier, options)
    root_url + url[1..-1]
  end
end
