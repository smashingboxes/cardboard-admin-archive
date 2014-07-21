require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../dummy/config/environment', __FILE__ )

Dir[Cardboard::Engine.root.join("app", "models","cardboard", "field", "*.rb").to_s].each {|file| require file }


require "rails/test_help"

require 'faker'
require 'database_cleaner'
require "minitest/autorun"
require "minitest/rails"
require "minitest/rails/capybara"
require 'minitest/unit'
require 'minitest/mock'
require Cardboard::Engine.root.join('lib/cardboard/helpers/seed.rb')

require File.expand_path('../factories.rb', __FILE__)

begin; require 'turn/autorun'; rescue LoadError; end

DatabaseCleaner.strategy = :truncation

# Uncomment if you want awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  include Warden::Test::Helpers
  Warden.test_mode!

  def cardboard
    Cardboard::Engine.routes.url_helpers
  end
end

if Rails.configuration.database_configuration['test']['database'] == ':memory:'
  puts "creating sqlite in memory database"
  load "#{Rails.root}/db/schema.rb"
end
