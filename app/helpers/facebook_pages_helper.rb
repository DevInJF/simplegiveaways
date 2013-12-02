module FacebookPagesHelper

  def subscription_message(facebook_page)
    if facebook_page.has_active_subscription?
      active_subscription_message
    elsif facebook_page.has_inactive_subscription?
      inactive_subscription_message
    elsif facebook_page.has_free_trial_remaining?
      free_trial_message
    else
      no_subscription_message
    end
  end

  def active_subscription_message(facebook_page)
    "<strong>#{facebook_page.name}</strong> is subscribed to the #{facebook_page.subscription_plan_name} plan. Go ahead and start the giveaway when you're ready. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.<br /><br />When you click <strong>Next</strong>, your giveaway will be published to your page.".html_safe
  end

  def inactive_subscription_message(facebook_page)
    "<strong>#{facebook_page.name}</strong> is subscribed to the #{facebook_page.subscription_plan_name} plan, however, the plan has been deactivated due to outdated billing information. Please correct your billing information and then start the giveaway when you're ready. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
  end

  def free_trial_message(facebook_page)
    "Since this is the first giveaway for <strong>#{facebook_page.name}</strong>, it's on the house &mdash; free with no strings attached. Go ahead and start the giveaway when you're ready. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
  end

  def no_subscription_message(facebook_page)
    "<strong>#{facebook_page.name}</strong> is not currently subscribed to any plan. Please choose the plan that is right for you and then start the giveaway when you're ready. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
  end

  def no_subscription_schedule_message(facebook_page)
    "<strong>#{facebook_page.name}</strong> is not currently subscribed to any plan. In order to schedule a giveaway to start automatically, a subscription is required. Please choose the plan that is right for you and then we will automatically publish the giveaway at the chosen date and time. If you decide not to choose a plan right now, we will save your giveaway but ignore the scheduling information so you can come back to it in the future. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
  end
end
