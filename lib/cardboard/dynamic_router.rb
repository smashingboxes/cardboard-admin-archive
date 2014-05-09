module Cardboard
  class DynamicRouter

    def self.load
      return unless ActiveRecord::Base.connection.table_exists? :cardboard_pages

      Rails.application.routes.draw  do
        routes = @set.named_routes.routes
        Cardboard::Page.includes(:url_object, :template).each do |page|
          url = page.url_object
          template = page.template
          
          get url.to_s, :to => template.controller_action || "pages##{template.identifier}", defaults: { id: url.to_s }

          if !routes[:root] && page.root?
            root :to => template.controller_action || "pages##{template.identifier}"
          end
        end
      end
    end

    def self.reload
      Rails.application.routes_reloader.reload!
    end
  end
end