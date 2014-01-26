class AddTalkingAboutCountToFacebookPages < ActiveRecord::Migration
  def change
    add_column :facebook_pages, :talking_about_count, :integer, default: 0
  end
end
