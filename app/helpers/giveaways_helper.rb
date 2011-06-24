module GiveawaysHelper
  
  def mandatory_likes_list(giveaway)
    pages = giveaway.mandatory_likes.split(",").collect do |page|
      ("<a href='#{page}'>#{page}</a><br />").html_safe
    end
    pages.join.html_safe
  end
end
