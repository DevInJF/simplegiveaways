class AddAnalyticsToGiveaway < ActiveRecord::Migration
  def change
    add_column :giveaways, :analytics, :text
  end
end
