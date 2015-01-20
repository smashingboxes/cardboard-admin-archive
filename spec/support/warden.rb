RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :request
  Warden.test_mode!
end
