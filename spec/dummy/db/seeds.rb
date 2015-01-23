AdminUser.where(email: 'admin@smashingboxes.com').first_or_create(
  password: 'password'
)

Piano.where(name: 'Steinway').first_or_create
