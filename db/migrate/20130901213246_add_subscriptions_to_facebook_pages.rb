class AddSubscriptionsToFacebookPages < ActiveRecord::Migration
  def change
    change_table :facebook_pages do |t|
      t.references :subscription, index: true
    end
  end
  def down
    change_table :facebook_pages do |t|
      t.remove :subscription_id
    end
  end
end
