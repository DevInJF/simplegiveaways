# -*- encoding : utf-8 -*-
class CreateGiveaways < ActiveRecord::Migration
  def change
    create_table :giveaways, :force => true do |t|
      t.string   :title
      t.text     :description
      t.datetime :start_date
      t.datetime :end_date
      t.string   :prize
      t.text     :terms
      t.string   :giveaway_url
      t.string   :image_file_name
      t.string   :image_content_type
      t.integer  :image_file_size
      t.string   :feed_image_file_name
      t.string   :feed_image_content_type
      t.integer  :feed_image_file_size
      t.integer  :facebook_page_id
      t.text     :preferences
      t.timestamps
    end

    add_index :giveaways, [:title, :facebook_page_id], :unique => true
  end
end
