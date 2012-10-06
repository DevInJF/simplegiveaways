class GiveawayNoticeMailer < ActionMailer::Base

  def start(recipient_emails)
    [recipient_emails].flatten.each do |recipient_email|
      mail subject: "Your Giveaway Has Begun",
           to: recipient_email,
           from: "support@simplegiveaways.com"
    end
  end

  def end(recipient_emails)
    [recipient_emails].flatten.each do |recipient_email|
      mail subject: "Your Giveaway Has Ended",
           to: recipient_email,
           from: "support@simplegiveaways.com"
    end
  end
end
