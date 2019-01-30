class AddIgnoreCertsToShiftType < ActiveRecord::Migration[4.2]
  def self.up
    add_column :shift_types, :ignore_certs, :boolean, :default => false
  end

  def self.down
    remove_column :shift_types, :ignore_certs
  end
end
