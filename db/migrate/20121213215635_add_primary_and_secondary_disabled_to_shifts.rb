class AddPrimaryAndSecondaryDisabledToShifts < ActiveRecord::Migration
  def self.up
    add_column :shifts, :primary_disabled, :boolean, :default => false
    add_column :shifts, :secondary_disabled, :boolean, :default => false
  end

  def self.down
    remove_column :shifts, :primary_disabled
    remove_column :shifts, :secondary_disabled
  end
end
