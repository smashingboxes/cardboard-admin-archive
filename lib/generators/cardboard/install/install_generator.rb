require 'rails/generators/active_record'

module Cardboard
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Installs Cardboard and generates the necessary migrations"

      argument :name, :type => :string, :default => Rails.application.class.name.split("::").first.titlecase      
      class_option "user-class", :type => :string
      class_option "no-migrate", :type => :boolean
      # hook_for :users, :default => "devise", :desc => "Admin user generator to run. Skip with --skip-users"


      def self.source_root
        @_cardboard_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer
        if generating?
          @site_title = ask("What is the site name? [#{@name}]").presence || @name

          @user_class = options["user-class"].presence ||
                        ask("What is your user class called? [AdminUser]").presence ||
                        'AdminUser'
          user_class_underscore = @user_class.underscore
          #TODO: check that this class really exists
          @current_user_helper = "current_#{user_class_underscore}"
          @authentication_method = "authenticate_#{user_class_underscore}!"
          @logout_link_path = "destroy_#{user_class_underscore}_session_path"

          unless defined?(Devise)
            @current_user_helper = ask("What is the current_user helper called in your app? [#{@current_user_helper}]").presence || @current_user_helper
            @authentication_method = ask("What is the authenticate! helper called in your app? [#{@authentication_method}]").presence || @authentication_method
            @logout_link_path = ask("What is the signout link of your app [#{@logout_link_path}]?").presence || @logout_link_path
          end
        end

        path = "#{Rails.root}/config/initializers/cardboard.rb"
        # if File.exists?(path)
        #   p "Skipping config/initializers/cardboard.rb creation, as file already exists!"
        # else
          p "Adding cardboard initializer (config/initializers/cardboard.rb)..."
          template 'cardboard.rb.erb', path
          require path if File.exists?(path) # Load the configuration
        # end
      end

      def setup_cardboard_yaml
        p "Generating a default config/cardboard.yml file..."
        copy_file 'cardboard.yml', 'config/cardboard.yml'
      end

      def setup_directory
        empty_directory "app/views/pages"
      end

      def setup_routes
        p "Mounting Cardboard::Engine at \"/cardboard\" in config/routes.rb..."
        inject_into_file "config/routes.rb", "\n  mount Cardboard::Engine => \"/cardboard\"", :after => /routes.draw.do\n/
      end

      def create_assets
        p "Generating cardboard assets..."
        generate "cardboard:assets"
      end

      def create_migrations
        p "Copying over migrations..."
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1
        end
      end
      # def install_migrations
      #   puts "Copying over migrations..."
      #   Dir.chdir(Rails.root) do
      #     `rake cardboard:install:migrations`
      #   end
      # end

      # def setup_helpers
      #   inject_into_file "app/controllers/application_controller.rb", "\n  helper Cardboard::ApplicationHelper", :after => /ApplicationController.*/
      # end
    protected

      def p(msg)
        puts msg if generating?
      end

      def generating?
        :invoke == behavior
      end

      def destroying?
        :revoke == behavior
      end 
    end
  end
end
