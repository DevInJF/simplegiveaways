ActiveAdmin.register User do

  # Create sections on the index screen
  scope :all, :default => true

  # Filterable attributes on the index screen
  filter :email
  filter :created_at

  # Customize columns displayed on the index screen in the table
  index do
    column :email
    column :created_at
    default_actions
  end

end