class AddIgnoreSuspendedToShiftTypes < ActiveRecord::Migration
  def self.up
		add_column :shift_types, :ignore_suspended, :boolean, :default => false
  end

  def self.down
		remove_column :shift_types, :ignore_primary
  end
end
