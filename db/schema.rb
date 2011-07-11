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

ActiveRecord::Schema.define(:version => 20110711000554) do

  create_table "accessory_fb_pages", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "pid"
    t.string   "avatar"
    t.text     "description"
    t.integer  "likes"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "giveaway_id"
  end

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "credit_cards", :force => true do |t|
    t.string   "nickname"
    t.string   "name"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "type"
    t.string   "number"
    t.date     "expiration"
    t.string   "cvv"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards_users", :id => false, :force => true do |t|
    t.integer "credit_card_id", :null => false
    t.integer "user_id",        :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "entries", :force => true do |t|
    t.string   "email"
    t.boolean  "has_liked_mandatory"
    t.boolean  "has_liked_primary"
    t.string   "name"
    t.string   "fb_url"
    t.datetime "datetime_entered"
    t.boolean  "has_shared"
    t.integer  "share_count"
    t.integer  "invite_count"
    t.integer  "convert_count"
    t.integer  "giveaway_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["email", "giveaway_id"], :name => "index_entries_on_email_and_giveaway_id", :unique => true

  create_table "facebook_pages", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "pid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.text     "description"
    t.integer  "likes"
    t.string   "url"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_page_id"
    t.string   "prize"
    t.text     "mandatory_likes"
    t.text     "terms"
    t.string   "giveaway_url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "feed_image_file_name"
    t.string   "feed_image_content_type"
    t.integer  "feed_image_file_size"
  end

  add_index "giveaways", ["title", "facebook_page_id"], :name => "index_giveaways_on_title_and_facebook_page_id", :unique => true

  create_table "giveaways_users", :id => false, :force => true do |t|
    t.integer "giveaway_id", :null => false
    t.integer "user_id",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
