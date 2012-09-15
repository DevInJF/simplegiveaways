class AddUniquesToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :uniques, :integer, default: 0
  end
end
