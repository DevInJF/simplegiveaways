class Refresh

  def self.facebook_page_like_count
    FacebookPage.find_each(:all, :batch_size => 5) do |pages|
      pages.each do |page|
        page.refresh_likes
      end
      sleep 2.seconds
    end
  end

  def self.giveaway_analytics
    Giveaway.find_each(:all, :batch_size => 5) do |giveaways|
      giveaways.each do |giveaway|
        giveaway.refresh_analytics
      end
      sleep 2.seconds
    end
  end
end