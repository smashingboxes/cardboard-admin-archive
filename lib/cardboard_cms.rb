require "cardboard/engine"

module Cardboard
  autoload :Application,              'cardboard/application'

  class << self

    attr_accessor :application, :resource_controllers

    def application
      @application ||= ::Cardboard::Application.new
    end

    def user_class
      return false unless application.user_class
      @user_class ||= application.user_class.to_s.camelize.constantize
    end

    def used_as_cms?
      @used_as_cms = Cardboard::Page.count > 0 if @used_as_cms.nil? #handle false
      @used_as_cms
    end

    def set_resource_controllers
      Dir[Rails.root.join('app/controllers/cardboard/*_controller.rb')].map.each do |controller|
        require_dependency controller
      end
      Cardboard.resource_controllers = Cardboard::ResourceController.descendants
    end

    # Gets called within the initializer
    def setup
      yield(application)
    end
  end

end


