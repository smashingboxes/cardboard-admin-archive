require "cardboard/engine"

module Cardboard
  autoload :Application,              'cardboard/application'

  class << self

    attr_accessor :application, :resource_controllers

    def resource_controllers
      @resource_controllers ||= Cardboard::ResourceController.descendants
    end

    def application
      @application ||= ::Cardboard::Application.new
    end

    def user_class
      return false unless application.user_class
      @user_class ||= application.user_class.to_s.camelize.constantize
    end

    def used_as_cms?
      @used_as_cms = Cardboard::Template.count > 0 if @used_as_cms.nil? #handle false
      @used_as_cms
    end

    def used_with_templates?
      @used_with_templates = Cardboard::Template.where("is_page = ? OR is_page IS NULL", false).count > 0 if @used_with_templates.nil? #handle false
      @used_with_templates
    end

    def used_with_settings?
      @used_with_settings = Cardboard::Setting.count > 0 if @used_with_settings.nil? #handle false
      @used_with_settings
    end

    def set_resource_controllers
      # might not be needed in production
      Dir[Rails.root.join('app/controllers/cardboard/*_controller.rb')].map.each do |controller|
        require_dependency controller
      end
    end

    # Gets called within the initializer
    def setup
      yield(application)
    end
  end

end


