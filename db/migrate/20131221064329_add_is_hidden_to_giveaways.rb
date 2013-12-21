class AddIsHiddenToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :is_hidden, :boolean, default: false
  end
end
