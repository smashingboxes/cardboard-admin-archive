Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include Capybara::DSL, type: :request
  config.include Capybara::Webkit::RspecMatchers, type: :request
end
