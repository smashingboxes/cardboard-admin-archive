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

      def validate_model_exists
        begin
          fields
        rescue Exception => e
          raise "Model #{singular_table_name.classify} does not exist. Try running `rails g model #{singular_table_name.classify}`"
        end
      end

      def generate_controller_file
        template "admin_controller.rb", "app/controllers/#{controller_name}.rb"
      end

      def generate_view_files
        empty_directory "app/views/cardboard/#{plural_table_name}"
        template "#{options.markup}/index.html.slim", "app/views/cardboard/#{plural_table_name}/index.html.#{options.markup}"
        template "#{options.markup}/_fields.html.slim", "app/views/cardboard/#{plural_table_name}/_fields.html.#{options.markup}"
        template "#{options.markup}/edit.html.slim", "app/views/cardboard/#{plural_table_name}/edit.html.#{options.markup}"
        template "#{options.markup}/new.html.slim", "app/views/cardboard/#{plural_table_name}/new.html.#{options.markup}"
      end

      private

      def fields
        @_fields ||= singular_table_name.classify.constantize.column_names.reject{|k| %w[id created_at updated_at].include?(k) || k.empty?}
      end
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
