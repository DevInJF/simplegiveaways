class CreateAccessoryFbPages < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table :accessory_fb_pages
  end
end
