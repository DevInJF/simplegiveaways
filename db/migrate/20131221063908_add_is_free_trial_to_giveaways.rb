class AddIsFreeTrialToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :is_free_trial, :boolean, default: false
  end
end
