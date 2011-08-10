class DropAccessoryFacebookPages < ActiveRecord::Migration
  def self.up
    drop_table :accessory_fb_pages
  end

  def self.down
    create_table :accessory_fb_pages do |t|
      t.string   "name"
      t.string   "category"
      t.string   "pid"
      t.string   "avatar"
      t.text     "description"
      t.integer  "likes"
      t.string   "url"
      t.timestamps
    end
  end
end
