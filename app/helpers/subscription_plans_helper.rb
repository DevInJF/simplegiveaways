module SubscriptionPlansHelper

  def stripe_button(plan)
    haml_tag :script, class: 'stripe-button', "data-amount" => "#{plan.price_in_cents_per_cycle}", "data-name" => "Simple Giveaways", "data-description" => "#{plan.name}", "data-label" => price_label(plan), "data-key" => Rails.configuration.stripe.publishable_key, :src => "https://checkout.stripe.com/v2/checkout.js"
  end

  def price_label(plan)
    if plan.is_free_trial?
      "FREE"
    elsif plan.is_onetime?
      plan.price
    elsif plan.is_monthly?
      "#{plan.price}<span class='billing-cycle'>/month</span>".html_safe
    elsif plan.is_yearly?
      "#{plan.price}<span class='billing-cycle'>/year</span>".html_safe
    end
  end

  def basic_plan_name_string(plan)
    plan.name.gsub(/\s\(.*\)/, '')
  end

  def page_count_feature_string(plan)
    plan.is_single_page? ? '1 Facebook Page' : 'Unlimited Facebook Pages'
  end

  def giveaway_count_feature_string(plan)
    plan.is_free_trial? ? '1 Giveaway' : 'Unlimited Giveaways'
  end

  def white_label_feature_string(plan)
    str = plan.is_yearly? ? 'White-label Service' : '<strike>White-label Service</strike>'
    str.html_safe
  end

  def subscription_message(sub_object)
    if sub_object.has_free_trial_remaining?
      free_trial_message(sub_object)
    elsif sub_object.has_active_subscription?
      active_subscription_message(sub_object)
    elsif sub_object.has_inactive_subscription?
      inactive_subscription_message(sub_object)
    else
      no_subscription_message(sub_object)
    end
  end

  def plan_string(sub_object)
    ps = if sub_object.subscription_plan.is_single_page?
      "<strong>#{sub_object.name}</strong> is subscribed to the <strong>#{sub_object.subscription_plan_name}</strong> plan for <strong>#{sub_object.subscription.facebook_pages.first.name}</strong>."
    else
      "<strong>#{sub_object.name}</strong> is subscribed to the <strong>#{sub_object.subscription_plan_name}</strong> plan."
    end
    if sub_object.subscription.cancellation_pending?
      "#{ps}<br /><br /><i class='warning icon'></i>Your subscription will be <strong>cancelled</strong> on #{sub_object.subscription.activate_next_after}."
    elsif sub_object.subscription.downgrade_pending?
      "#{ps}<br /><br /><i class='warning icon'></i>Your subscription will be <strong>downgraded</strong> to <strong>#{sub_object.subscription.next_plan.name}</strong> on #{sub_object.subscription.activate_next_after}."
    else
      "#{ps}<br /><br /><i class='refresh icon'></i>Your subscription will be <strong>renewed</strong> on <strong>#{sub_object.subscription.current_period_end}</strong>."
    end
  end

  def active_subscription_message(sub_object)
    if sub_object.is_a? FacebookPage
      "<strong>#{sub_object.name}</strong> is subscribed to the <strong>#{sub_object.subscription_plan_name}</strong> plan. Go ahead and start the giveaway when you're ready. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.<br /><br />When you click <strong>Next</strong>, your giveaway will be published to your page.".html_safe
    elsif sub_object.is_a? User
      "#{plan_string(sub_object)}<br /><br /><i class='info icon'></i>You may update your plan.<br /><ul><li><strong>Upgrades</strong> will be automatically prorated for unused time on the old plan.</li><li><strong>Downgrades</strong> will not be prorated. Instead, the new plan will be activated at the end of the current billing cycle.</li><li><strong>Cancellations</strong> will not be refunded. Instead, your plan will not be renewed at the end of the current billing cycle.</li></ul> Thank you for using <strong>Simple Giveaways</strong>.".html_safe
    end
  end

  def inactive_subscription_message(sub_object)
    if sub_object.is_a? FacebookPage
      "<strong>#{sub_object.name}</strong> is subscribed to the #{sub_object.subscription_plan_name} plan, however, the plan has been deactivated due to outdated billing information. Please correct your billing information and then start the giveaway when you're ready. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
    elsif sub_object.is_a? User
      "<strong>#{sub_object.name}</strong> is subscribed to the #{sub_object.subscription_plan_name} plan, however, the plan has been deactivated due to outdated billing information. Please correct your billing information and don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
    end
  end

  def free_trial_message(sub_object)
    "Since this is the first giveaway for <strong>#{sub_object.name}</strong>, it's on the house &mdash; free with no strings attached. Go ahead and start the giveaway when you're ready. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
  end

  def no_subscription_message(sub_object)
    if sub_object.is_a? FacebookPage
      "<strong>#{sub_object.name}</strong> is not currently subscribed to any plan. Please choose the plan that is right for you and then start the giveaway when you're ready. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
    elsif sub_object.is_a? User
      "<strong>#{sub_object.name}</strong> is not currently subscribed to any plan. Please choose the plan that is right for you and don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
    end
  end

  def no_subscription_schedule_message(sub_object)
    "<strong>#{sub_object.name}</strong> is not currently subscribed to any plan. In order to schedule a giveaway to start automatically, a subscription is required. Please choose the plan that is right for you and then we will automatically publish the giveaway at the chosen date and time. If you decide not to choose a plan right now, we will save your giveaway but ignore the scheduling information so you can come back to it in the future. Good luck and please don't hesitate to contact us for any help or advice. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
  end
end
