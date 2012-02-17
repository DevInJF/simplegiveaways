# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120217015438) do

  create_table "entries", :force => true do |t|
    t.string   "email"
    t.boolean  "has_liked",        :default => false
    t.string   "name"
    t.string   "fb_url"
    t.datetime "datetime_entered"
    t.integer  "share_count",      :default => 0
    t.integer  "request_count",    :default => 0
    t.integer  "convert_count",    :default => 0
    t.integer  "giveaway_id"
    t.string   "status"
    t.string   "uid"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "entries", ["email", "giveaway_id"], :name => "index_entries_on_email_and_giveaway_id", :unique => true

  create_table "facebook_pages", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "pid"
    t.string   "token"
    t.string   "avatar"
    t.text     "description"
    t.integer  "likes"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "facebook_pages_users", :id => false, :force => true do |t|
    t.integer "facebook_page_id", :null => false
    t.integer "user_id",          :null => false
  end

  create_table "giveaways", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "prize"
    t.text     "terms"
    t.string   "giveaway_url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "feed_image_file_name"
    t.string   "feed_image_content_type"
    t.integer  "feed_image_file_size"
    t.integer  "facebook_page_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "giveaways", ["title", "facebook_page_id"], :name => "index_giveaways_on_title_and_facebook_page_id", :unique => true

  create_table "identities", :force => true do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "email"
    t.string   "avatar"
    t.string   "profile_url"
    t.string   "location"
    t.integer  "user_id"
    t.integer  "login_count"
    t.datetime "logged_in_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "identities", ["uid", "provider"], :name => "index_identities_on_uid_and_provider", :unique => true
  add_index "identities", ["user_id"], :name => "index_identities_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
