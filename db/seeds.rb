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
  email: 'testadmin2@app.com',
  password: 'Test1234!', # Set your desired password here
  password_confirmation: 'Test1234!', # Confirm the password
  username: 'trails_admin6',
  first_name: 'Trails',
  last_name: 'Admin',
  birthday: '1990-01-01',
  role: 2,
  # confirmed_at: Time.current # Automatically confirm the account
)

# admin.skip_confirmation_notification! # Skip sending confirmation email
if admin.save
  admin.update!(confirmed_at: Time.current)
  puts 'Admin user created successfully.'
end

user000 = User.new(
  email: 'user0005@app.com',
  password: 'Test1234!', # Set your desired password here
  password_confirmation: 'Test1234!', # Confirm the password
  username: 'user0_trader5',
  first_name: 'User',
  last_name: '000',
  birthday: '1990-01-01',
  role: 1,
  confirmed_at: Time.current # Automatically confirm the account
)

# user000.skip_confirmation_notification! # Skip sending confirmation email
if user000.save!
  user000.confirm
  puts 'User000 user created successfully.'
end