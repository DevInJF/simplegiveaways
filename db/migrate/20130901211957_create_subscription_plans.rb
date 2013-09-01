class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.string   :name
      t.text     :description
      t.integer  :price_in_cents_per_cycle
      t.boolean  :is_single_page
      t.boolean  :is_multi_page
      t.boolean  :is_onetime
      t.boolean  :is_monthly
      t.boolean  :is_yearly

      t.timestamps
    end
  end
end
