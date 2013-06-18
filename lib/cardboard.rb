require "cardboard/engine"

module Cardboard
  autoload :Application,              'cardboard/application'
  # autoload :Devise,                   'cardboard/devise'


  class << self

    attr_accessor :application, :resource_controllers

    def application
      @application ||= ::Cardboard::Application.new
    end

    def user_class
      @user_class ||= application.user_class.to_s.camelize.constantize
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


