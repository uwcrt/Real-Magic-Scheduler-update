class AddIgnoreSuspendedToShiftTypes < ActiveRecord::Migration[4.2]
  def self.up
    add_column :shift_types, :ignore_suspended, :boolean, :default => false
  end

  def self.down
    remove_column :shift_types, :ignore_primary
  end
end
