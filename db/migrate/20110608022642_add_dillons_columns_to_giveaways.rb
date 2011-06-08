class AddDillonsColumnsToGiveaways < ActiveRecord::Migration
  def self.up
    add_column :giveaways, :prize, :string
    add_column :giveaways, :feed_content, :string
    add_column :giveaways, :must_like, :boolean
    add_column :giveaways, :optional_likes, :text
    add_column :giveaways, :terms, :text
  end

  def self.down
    remove_column :giveaways, :prize
    remove_column :giveaways, :feed_content
    remove_column :giveaways, :must_like
    remove_column :giveaways, :optional_likes
    remove_column :giveaways, :terms
  end
end
