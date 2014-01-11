class AddViralUniquesToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :viral_uniques, :integer, default: 0
  end
end
