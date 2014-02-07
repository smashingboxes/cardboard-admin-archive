puts "Generating Admin User"
AdminUser.create(email: "michael@smashingboxes.com", password: "1234567890", password_confirmation: "1234567890") if AdminUser.first.nil?

Cardboard::Page.all.each{|page| page.update_attributes(:template => Cardboard::Template.find_by(:identifier => page.identifier))}