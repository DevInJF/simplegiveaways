# -*- encoding : utf-8 -*-
module GiveawaysHelper

  def stats(count, text)
    if count == 0
      count_display = 0
      count = 2
    end
    "<div class='value highlight'>#{count_display}</div><h5 class='key'>#{pluralize_without_count(count, text)}</h5>".html_safe
  end

  def mandatory_likes_list(giveaway)
    pages = giveaway.mandatory_likes.split(",").collect do |page|
      ("<a href='#{page}'>#{page}</a><br />").html_safe
    end
    pages.join.html_safe
  end
end
