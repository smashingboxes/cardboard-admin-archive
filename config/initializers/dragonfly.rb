require 'dragonfly/rails/images'
# https://raw.github.com/markevans/dragonfly/master/lib/dragonfly/rails/images.rb

# if Rails.env.development?
#   app = Dragonfly[:dummy].configure do |c|
#     c.allow_fetch_file = true #used for default images, only in development
#     # c.protect_from_dos_attacks = true
#     # c.secret = "some secret here..."
#   end
#   app.configure_with(:rails)
#   app.configure_with(:imagemagick)
#   Rails.application.middleware.insert_after Rack::Cache, Dragonfly::Middleware, :dummy
# end