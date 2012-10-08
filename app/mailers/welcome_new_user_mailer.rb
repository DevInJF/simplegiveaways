require 'haml'
require 'haml/template/plugin'

class WelcomeNewUserMailer < ActionMailer::Base

  def welcome(recipient_identity)
    user_name = recipient_identity.user.name
    @user_first_name = user_name.split(" ")[0] rescue user_name
    email_with_name = "#{@user_first_name} <#{recipient_identity.email}>"
    mail subject: 'Welcome to Simple Giveaways',
         to: email_with_name,
         from: 'support@simplegiveaways.com',
         template_path: 'mailers/welcome_new_user_mailer',
         template_name: 'welcome'
  end
end
