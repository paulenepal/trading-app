# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Admin User

admin = User.new(
  email: 'admin@app.com',
  password: 'admin1234', # Set your desired password here
  password_confirmation: 'admin1234', # Confirm the password
  username: 'admin',
  first_name: 'Admin',
  last_name: 'User',
  birthday: '1990-01-01',
  role: 2,
  confirmed_at: Time.now # Automatically confirm the account
)

admin.skip_confirmation_notification! # Skip sending confirmation email
admin.save!

puts 'Admin user created successfully.'

user000 = User.new(
  email: 'user000@app.com',
  password: '1234567', # Set your desired password here
  password_confirmation: '1234567', # Confirm the password
  username: 'user000',
  first_name: 'User',
  last_name: '000',
  birthday: '1990-01-01',
  role: 1,
  confirmed_at: Time.now # Automatically confirm the account
)

user000.skip_confirmation_notification! # Skip sending confirmation email
user000.save!

puts 'User000 user created successfully.'