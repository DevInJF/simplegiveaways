module GiveawaysHelper

  def status_label(giveaway)
    case giveaway.status
      when 'Active'
        label = <<-eos
          <div class="ui ribbon label teal">
            <strong>Active</strong><br />
            Started on #{datetime_mdy(giveaway.start_date)}<br />
            Ends on #{datetime_mdy(giveaway.end_date)}
          </div>
        eos
        label.html_safe
      when 'Pending'
        '<div class="ui ribbon label"><strong>Pending</strong></div>'.html_safe
      when 'Completed'
        label = <<-eos
          <div class="ui ribbon label red">
            <strong>Completed</strong><br />
            Started on #{datetime_mdy(giveaway.start_date)}<br />
            Ended on #{datetime_mdy(giveaway.end_date)}
          </div>
        eos
        label.html_safe
    end
  end

  def boolean_label(boolean)
    if boolean
      '<div class="ui small horizontal teal label">TRUE</div>'.html_safe
    else
      '<div class="ui small horizontal red label">FALSE</div>'.html_safe
    end
  end

  def start_date_label(giveaway)
    if giveaway.needs_subscription?
      "<span class='giveaway-start-date-warning popup-trigger' data-title='Inactive Start Date' data-content='A subscription is required in order to schedule a giveaway.<br /><br /><a class=\"ui mini teal button\" href=\"#{facebook_page_subscription_plans_path(giveaway.facebook_page)}\">Choose a Plan</a>' data-on='click'><i class='warning icon'></i><s>#{giveaway.start_date}</s></span>".html_safe
    else
      datetime_mdy(giveaway.start_date)
    end
  end
end
