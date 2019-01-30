class AddLimitToShiftType < ActiveRecord::Migration[4.2]
  def self.up
    add_column :shift_types, :limit, :integer, null: false, :default => 0
  end

  def self.down
    remove_column :shift_types, :limit
  end
end
