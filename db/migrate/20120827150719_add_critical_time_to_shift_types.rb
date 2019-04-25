class AddCriticalTimeToShiftTypes < ActiveRecord::Migration[4.2]
  def self.up
    add_column :shift_types, :critical_time, :integer, :default => 7
  end

  def self.down
    remove_column :shift_types, :critical_time
  end
end
