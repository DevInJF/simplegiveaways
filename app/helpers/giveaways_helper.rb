module GiveawaysHelper

  def status_label(giveaway)
    case giveaway.status
      when 'Active'
        '<div class="ui ribbon label green">Active</div>'.html_safe
      when 'Pending'
        '<div class="ui ribbon label">Pending</div>'.html_safe
      when 'Completed'
        '<div class="ui ribbon label red">Completed</div>'.html_safe
    end
  end

  def boolean_label(boolean)
    if boolean
      '<div class="ui small horizontal green label">TRUE</div>'.html_safe
    else
      '<div class="ui small horizontal red label">FALSE</div>'.html_safe
    end
  end
end
