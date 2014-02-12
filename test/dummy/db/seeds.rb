puts "Generating Admin User"
AdminUser.create(email: "michael@smashingboxes.com", password: "password") if AdminUser.first.nil?
