module Cardboard
  module Generators
    class ResourceGenerator < Rails::Generators::Base
      desc "Installs Cardboard in a rails 3 application"
      argument :resource_name, :type => :string
      #TODO: option for haml
      class_option  :markup, :type => :string, :default => "slim"

      def self.source_root
        @_cardboard_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def generate_controller_file
        empty_directory "app/controllers/cardboard"
        template "admin_controller.rb", "app/controllers/#{controller_name}.rb"
      end

      def generate_view_files
        empty_directory "app/views/cardboard/#{plural_table_name}"
        template "#{options.markup}/index.html.slim", "app/views/cardboard/#{plural_table_name}/index.html.#{options.markup}"
        template "#{options.markup}/_fields.html.slim", "app/views/cardboard/#{plural_table_name}/_fields.html.#{options.markup}"
        template "#{options.markup}/edit.html.slim", "app/views/cardboard/#{plural_table_name}/edit.html.#{options.markup}"
        template "#{options.markup}/new.html.slim", "app/views/cardboard/#{plural_table_name}/new.html.#{options.markup}"
        template "#{options.markup}/show.html.slim", "app/views/cardboard/#{plural_table_name}/show.html.#{options.markup}"
      end

      private

      def plural_table_name
        @_plural_table_name ||= singular_table_name.pluralize
      end
      def singular_table_name
        @_singular_table_name ||= resource_name.to_s.singularize.underscore
      end


      def controller_name
        "cardboard/#{plural_table_name}_controller"
      end

    end
  end
end
