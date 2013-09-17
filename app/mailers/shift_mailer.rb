class ShiftMailer < ActionMailer::Base
  self.default :from => "scheduler@crt.feds.ca"

  def update_email(shift, users_to_notify)
    @shift = shift
    subject = "CRT Shift Update"
    mail(:bcc => users_to_notify.map(&:email), :subject => subject)
  end

  def new_email(shift, users)
    @shift = shift
    subject = "New CRT Shift"

    users.each do |user|
      user.last_notified = Time.now
      user.save
    end

    mail(:bcc => users.map(&:email), :subject => subject)
  end
end
