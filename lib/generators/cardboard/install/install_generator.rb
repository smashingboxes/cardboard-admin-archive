require 'rails/generators/active_record'

module Cardboard
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Installs Cardboard and generates the necessary migrations"
      argument :name, :type => :string, :default => "AdminUser"

      hook_for :users, :default => "devise", :desc => "Admin user generator to run. Skip with --skip-users"

      def self.source_root
        @_cardboard_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer
        @underscored_user_name = name.underscore
        template 'cardboard.rb.erb', 'config/initializers/cardboard.rb'
        copy_file 'cardboard.yml', 'config/cardboard.yml'
      end

      def setup_directory
        empty_directory "app/views/pages"
        # template 'index.html.erb', 'app/views/pages/index.html.erb'
        # if options[:users].present?
        #   @user_class = name
        #   template 'admin_user.rb.erb', "app/admin/#{name.underscore}.rb"
        # end
      end

      def setup_routes
        inject_into_file "config/routes.rb", "\n  mount Cardboard::Engine => \"/cardboard\"", :after => /devise_for.*/
      end

      def create_assets
        generate "cardboard:assets"
      end

      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1
        end
      end

      # def setup_helpers
      #   inject_into_file "app/controllers/application_controller.rb", "\n  helper Cardboard::ApplicationHelper", :after => /ApplicationController.*/
      # end
    end
  end
end
