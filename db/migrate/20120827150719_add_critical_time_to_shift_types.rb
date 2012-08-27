class AddCriticalTimeToShiftTypes < ActiveRecord::Migration
  def self.up
    add_column :shift_types, :critical_time, :integer, :default => 7
  end

  def self.down
    remove_column :shift_types, :critical_time
  end
end
