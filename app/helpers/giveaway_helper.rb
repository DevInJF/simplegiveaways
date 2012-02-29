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

  def giveaway_terms(terms)
    terms = terms.values.reject(&:blank?).first
    if terms.match(/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix).present?
      "<a href='#{terms}'>#{terms}</a>".html_safe
    end
  end
end