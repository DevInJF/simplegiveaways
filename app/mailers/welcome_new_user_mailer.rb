class WelcomeNewUserMailer < ActionMailer::Base

  def welcome(recipient_email)
    mail :subject => "Welcome to Simple Giveaways",
         :to      => recipient_email,
         :from    => "support@simplegiveaways.com" # approved domains only!
  end
end