require 'codeclimate-test-reporter'
SimpleCov.start 'rails' do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../dummy/config/environment", __FILE__)

Dir[Cardboard::Engine.root.join("app", "models","cardboard", "field", "*.rb").to_s].each {|file| require file }

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-webkit'
require 'capybara/webkit/matchers'

require 'faker'
require 'factory_girl'
require 'database_cleaner'
require Cardboard::Engine.root.join('lib/cardboard/helpers/seed.rb')

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), '/support/**/*.rb')].each { |f| require f }

# Requires factories from gem's rails_helper as opposed to changing
# `config.generators { |g| g.factory_girl dir: '' } in Dummy application
Dir[File.join(File.dirname(__FILE__), '/factories/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["LOGGER"]

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
