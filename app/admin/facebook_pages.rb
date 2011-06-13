ActiveAdmin.register FacebookPage do

  # Create sections on the index screen
  scope :all, :default => true

  # Filterable attributes on the index screen
  filter :name
  filter :likes
  filter :created_at

  # Customize columns displayed on the index screen in the table
  index do
    column :name
    column :likes
    column :created_at
    default_actions
  end

end