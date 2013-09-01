class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :subscription_plan

      t.timestamps
    end
  end
end
