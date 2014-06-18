module Cardboard
  class DynamicRouter

    def self.load
      
      Rails.application.routes.draw  do
        return unless ActiveRecord::Base.connection.table_exists? :cardboard_urls
        Cardboard::Url.where("slugs_backup IS NOT NULL").each do |url|
          for link in url.slugs_backup
            get link, to: redirect(url.to_s)
          end
        end

        return unless ActiveRecord::Base.connection.table_exists? :cardboard_pages
        routes = @set.named_routes.routes
        Cardboard::Page.includes(:url_object, :template).each do |page|
          url = page.url_object
          template = page.template
          
          get url.to_s, :to => template.controller_action || "pages##{template.identifier}", defaults: { identifier: template.identifier }

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