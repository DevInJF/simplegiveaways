class WelcomeNewUserMailer < ActionMailer::Base

  def welcome(recipient_identity)
    @identity = recipient_identity
    mail subject: 'Welcome to Simple Giveaways',
         to: @identity.email,
         from: 'support@simplegiveaways.com',
         template_path: 'mailers'
  end
end