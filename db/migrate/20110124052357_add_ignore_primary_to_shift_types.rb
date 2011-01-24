class AddIgnorePrimaryToShiftTypes < ActiveRecord::Migration
  def self.up
    add_column :shift_types, :ignore_primary, :boolean, :default => false
  end

  def self.down
    remove_column :shift_types, :ignore_primary
  end
end
