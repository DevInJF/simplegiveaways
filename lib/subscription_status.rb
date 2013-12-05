module SubscriptionStatus

  def has_active_subscription?
    has_free_trial_remaining? || subscription && subscription.active?
  end

  def has_inactive_subscription?
    subscription && subscription.inactive?
  end

  def has_monthly_subscription?
    subscription && subscription_plan.is_monthly?
  end

  def has_yearly_subscription?
    subscription && subscription_plan.is_yearly?
  end

  def has_single_page_subscription?
    subscription && subscription_plan.is_single_page?
  end

  def has_multi_page_subscription?
    subscription && subscription_plan.is_multi_page?
  end

  def needs_subscription?
    !has_free_trial_remaining? && !has_active_subscription?
  end

  def subscription_plan
    subscription.subscription_plan rescue nil
  end

  def has_free_trial_remaining?
    no_active_giveaways? && no_completed_giveaways?
  end

  def subscription_plan_name
    subscription.subscription_plan.name rescue nil
  end
end
