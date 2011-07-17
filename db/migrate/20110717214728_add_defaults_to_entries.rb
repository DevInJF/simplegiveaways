class AddDefaultsToEntries < ActiveRecord::Migration
  def self.up
    change_column_default :entries, :has_liked_mandatory, false
    change_column_default :entries, :has_liked_primary, false
    change_column_default :entries, :share_count, 0
    change_column_default :entries, :request_count, 0
    change_column_default :entries, :convert_count, 0
  end

  def self.down
    change_column_default :entries, :convert_count, nil
    change_column_default :entries, :request_count, nil
    change_column_default :entries, :share_count, nil
    change_column_default :entries, :has_liked_primary, nil
    change_column_default :entries, :has_liked_mandatory, nil
  end
end
