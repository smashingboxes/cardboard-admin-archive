require 'devise'

module Cardboard
  module Devise

    def self.config
      config = {
        # :path => Cardboard.application.default_namespace,
        # :controllers => Cardboard::Devise.controllers,
        :path_names => { :sign_in => 'login', :sign_out => "logout" }
      }

      # if ::Devise.respond_to?(:sign_out_via)
      #   logout_methods = [::Devise.sign_out_via, Cardboard.application.logout_link_method].flatten.uniq
      #   config.merge!( :sign_out_via => logout_methods)
      # end

      config
    end

    def self.controllers
      {
        :sessions => "active_admin/devise/sessions",
        :passwords => "active_admin/devise/passwords",
        :unlocks => "active_admin/devise/unlocks"
      }
    end

    module Controller
      extend ::ActiveSupport::Concern
      included do
        layout 'cardboard_logged_out'
        # helper ::Cardboard::ViewHelpers
      end

      # Redirect to the default namespace on logout
      def root_path
        # namespace = Cardboard.application.default_namespace.presence
        # root_path_method = [namespace, :root_path].compact.join('_')

        url_helpers = Rails.application.routes.url_helpers

        # path = if url_helpers.respond_to? root_path_method
        #          url_helpers.send root_path_method
        #        else
        #          # Guess a root_path when url_helpers not helpful
        #          "/#{namespace}"
        #        end

        # # NOTE: `relative_url_root` is deprecated by rails.
        # #       Remove prefix here if it is removed completely.
        # prefix = Rails.configuration.action_controller[:relative_url_root] || ''
        # prefix + path
      end
    end

    class SessionsController < ::Devise::SessionsController
      include ::Cardboard::Devise::Controller
    end

    class PasswordsController < ::Devise::PasswordsController
      include ::Cardboard::Devise::Controller
    end

    class UnlocksController < ::Devise::UnlocksController
      include ::Cardboard::Devise::Controller
    end

  end
end
