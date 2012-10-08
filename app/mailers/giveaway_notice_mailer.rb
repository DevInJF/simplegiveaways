require 'haml'
require 'haml/template/plugin'

class GiveawayNoticeMailer < ActionMailer::Base

  def start(recipient_users, giveaway)
    recipient_users.each do |recipient_user|
      begin
        @giveaway = giveaway
        @user_first_name = recipient_user.name.split(" ")[0] rescue recipient_user.name
        mail subject: 'Your Giveaway Has Begun',
             to: recipient_user.identities.pop.email,
             from: 'support@simplegiveaways.com',
             template_path: 'mailers/giveaway_notice_mailer',
             template_name: 'start'
      rescue StandardError
      end
    end
  end

  def end(recipient_users, giveaway)
    recipient_users.each do |recipient_user|
      begin
        @giveaway = giveaway
        @user_first_name = recipient_user.name.split(" ")[0] rescue recipient_user.name
        mail subject: 'Your Giveaway Has Ended',
             to: recipient_user.identities.pop.email,
             from: 'support@simplegiveaways.com',
             template_path: 'mailers/giveaway_notice_mailer',
             template_name: 'end'
      rescue StandardError
      end
    end
  end
end
