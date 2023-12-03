class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: 'Welcome to Quiz')
  end
end
