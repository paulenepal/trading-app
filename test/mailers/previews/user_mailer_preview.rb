# Preview all emails at http://localhost:3001/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.first
    UserMailer.welcome_email(user)
  end
end
