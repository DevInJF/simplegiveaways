class Refresh

  def self.facebook_page_like_count
    FacebookPage.find_each(batch_size: 5) do |pages|
      [pages].flatten.each do |page|
        page.refresh_likes
      end
      sleep 2.seconds
    end
  end

  def self.giveaway_analytics
    Giveaway.active.find_each(batch_size: 5) do |giveaways|
      [giveaways].flatten.each do |giveaway|
        giveaway.refresh_analytics
      end
      sleep 2.seconds
    end
  end
end
