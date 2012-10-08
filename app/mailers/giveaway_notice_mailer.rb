require 'haml'
require 'haml/template/plugin'

class GiveawayNoticeMailer < ActionMailer::Base

  def start(user, giveaway)
    @giveaway = giveaway
    @user_first_name = user.name.split(" ")[0] rescue user.name
    mail subject: 'Your Giveaway Has Begun',
         to: user.identities.pop.email,
         from: 'support@simplegiveaways.com',
         template_path: 'mailers/giveaway_notice_mailer',
         template_name: 'start'
  end

  def end(user, giveaway)
    @giveaway = giveaway
    @user_first_name = user.name.split(" ")[0] rescue user.name
    mail subject: 'Your Giveaway Has Ended',
         to: user.identities.pop.email,
         from: 'support@simplegiveaways.com',
         template_path: 'mailers/giveaway_notice_mailer',
         template_name: 'end'
  end
end
