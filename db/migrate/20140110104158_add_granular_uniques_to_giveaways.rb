class AddGranularUniquesToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :fan_uniques, :integer, default: 0
    add_column :giveaways, :non_fan_uniques, :integer, default: 0
  end
end
