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
        '<div class="ui ribbon label red"><strong>Completed</strong></div>'.html_safe
    end
  end

  def boolean_label(boolean)
    if boolean
      '<div class="ui small horizontal teal label">TRUE</div>'.html_safe
    else
      '<div class="ui small horizontal red label">FALSE</div>'.html_safe
    end
  end
end
