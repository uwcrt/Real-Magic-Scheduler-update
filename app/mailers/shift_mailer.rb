class ShiftMailer < ActionMailer::Base
  default :from => "scheduler@crt.feds.ca"

  def update_email(shift)
    @shift = shift
    subject = "CRT Shift Update"
    users_to_notify = [@shift.primary, @shift.secondary].compact

    mail(:bcc => users_to_notify.map(&:email), :subject => subject)
  end

  def new_email(shift)
    @shift = shift
    subject = "New CRT Shift"
    users = User.notifiable_of_shift(@shift).to_a

    mail(:bcc => users.map(&:email), :subject => subject)

    users.each do |user|
      user.last_notified = Time.now
      user.save
    end
  end
end
