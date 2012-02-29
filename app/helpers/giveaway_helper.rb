module GiveawayHelper

  def giveaway_label(giveaway)
    status = giveaway.status
    case status
    when "Active"
      "<span class='label label-success'>Active</span>".html_safe
    when "Pending"
      "<span class='label label-warning'>Pending</span>".html_safe
    when "Complete"
      "<span class='label label-info'>Complete</span>".html_safe
    else
      ""
    end
  end
end