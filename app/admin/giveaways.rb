ActiveAdmin.register Giveaway do

  # Create sections on the index screen
  scope :all, :default => true

  # Filterable attributes on the index screen
  filter :title
  filter :description
  filter :content
  filter :is_live?
  filter :user_id
  filter :facebook_page_id
  filter :start_date
  filter :end_date
  filter :created_at

  # Customize columns displayed on the index screen in the table
  index do
    column :title
    column :description
    column :content
    column :is_live?
    column :user_id
    column :facebook_page_id
    column :start_date
    column :end_date
    column :created_at
    default_actions
  end

end