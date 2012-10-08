require 'haml'
require 'haml/template/plugin'

class GiveawayNoticeMailer < ActionMailer::Base

  def start(user, giveaway)
    @giveaway = giveaway
    @user_first_name = user.name.split(" ")[0] rescue user.name
    email_with_name = "#{@user_first_name} <#{user.identities.pop.email}>"
    mail subject: 'Your Giveaway Has Begun',
         to: email_with_name,
         from: 'support@simplegiveaways.com',
         template_path: 'mailers/giveaway_notice_mailer',
         template_name: 'start'
  end

  def end(user, giveaway)
    @giveaway = giveaway
    @user_first_name = user.name.split(" ")[0] rescue user.name
    email_with_name = "#{@user_first_name} <#{user.identities.pop.email}>"
    mail subject: 'Your Giveaway Has Ended',
         to: email_with_name,
         from: 'support@simplegiveaways.com',
         template_path: 'mailers/giveaway_notice_mailer',
         template_name: 'end'
  end
end
