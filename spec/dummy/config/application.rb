require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)
require 'cardboard_cms'

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Use gem's spec/factories instead
    config.generators do |g|
      g.factory_girl false
    end

    console do
      # FactoryGirl is not defined in test environment unless it runs from Rspec
      if defined? FactoryGirl
        FactoryGirl.definition_file_paths << Pathname.new('../factories')
        FactoryGirl.definition_file_paths.uniq!
        FactoryGirl.find_definitions
      end
    end
  end
end
