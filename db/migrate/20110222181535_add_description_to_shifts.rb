class AddDescriptionToShifts < ActiveRecord::Migration
  def self.up
    add_column :shifts, :description, :string
  end

  def self.down
    remove_column :shifts, :description
  end
end
