class AddPaperclipForFeedImage < ActiveRecord::Migration
  def self.up
    remove_column :giveaways, :feed_image
    add_column :giveaways, :feed_image_file_name, :string
    add_column :giveaways, :feed_image_content_type, :string
    add_column :giveaways, :feed_image_file_size, :integer
  end

  def self.down
    add_column :giveaways, :feed_image, :string
    remove_column :giveaways, :feed_image_file_name
    remove_column :giveaways, :feed_image_content_type
    remove_column :giveaways, :feed_image_file_size
  end
end
