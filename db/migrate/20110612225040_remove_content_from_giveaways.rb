class RemoveContentFromGiveaways < ActiveRecord::Migration
  def self.up
    remove_column :giveaways, :content
  end

  def self.down
    add_column :giveaways, :content, :string
  end
end
