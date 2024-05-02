class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @login_url = 'https//localhost:3000/onboarding'
    mail(to: @user.email, subject: 'Your account has been approved!') do |format|
      format.html { render 'user_mailer/welcome' }
    end
  end
end