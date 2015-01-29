AdminUser.where(email: 'admin@smashingboxes.com').first_or_create password: 'password'
