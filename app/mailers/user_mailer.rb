class UserMailer < ActionMailer::Base
  default :from => "crtscheduler@gmail.com"
  
  def password_reset_email(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
         :subject => "RMS Password Reset")
  end
  
  def new_user_email(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
         :subject => "Your RMS Account")
  end
end
