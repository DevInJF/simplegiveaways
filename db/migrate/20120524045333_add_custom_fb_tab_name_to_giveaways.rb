class AddCustomFbTabNameToGiveaways < ActiveRecord::Migration
  def change
    add_column  :giveaways, :custom_fb_tab_name, :string
  end
end
