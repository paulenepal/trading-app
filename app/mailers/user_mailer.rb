class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your account has been approved') do |format|
      format.html { render 'user_mailer/welcome' }
    end
  end
end