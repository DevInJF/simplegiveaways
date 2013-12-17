class AddSlugIndexesToFriendlyIdModels < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :giveaways, :slug, :string
    add_column :facebook_pages, :slug, :string
    add_index :users, :slug, unique: true
    add_index :giveaways, :slug, unique: true
    add_index :facebook_pages, :slug, unique: true
  end
end
