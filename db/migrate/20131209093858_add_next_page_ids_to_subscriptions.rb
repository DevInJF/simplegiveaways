class AddNextPageIdsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :next_page_ids, :text
  end
end
