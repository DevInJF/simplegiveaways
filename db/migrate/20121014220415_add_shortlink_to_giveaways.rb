class AddShortlinkToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :shortlink, :string
  end
end
