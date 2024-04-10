class UserMailer < ApplicationMailer
  def account_approved_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your account has been approved') do |format|
      format.html { render 'user_mailer/account_approved' }
    end
  end
end