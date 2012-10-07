require 'haml'
require 'haml/template/plugin'

class GiveawayNoticeMailer < ActionMailer::Base

  def start(recipient_users, giveaway)
    @giveaway = giveaway
    recipient_users.each do |recipient_user|
      begin
        @recipient_user = recipient_user
        mail subject: 'Your Giveaway Has Begun',
             to: @recipient_user.identities.pop.email,
             from: 'support@simplegiveaways.com',
             template_path: 'mailers/giveaway_notice_mailer',
             template_name: 'start'
      rescue StandardError
      end
    end
  end

  def end(recipient_users, giveaway)
    @giveaway = giveaway
    recipient_users.each do |recipient_user|
      begin
        @recipient_user = recipient_user
        mail subject: 'Your Giveaway Has Ended',
             to: @recipient_user.identities.pop.email,
             from: 'support@simplegiveaways.com',
             template_path: 'mailers/giveaway_notice_mailer',
             template_name: 'end'
      rescue StandardError
      end
    end
  end
end
