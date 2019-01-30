class AddDescriptionToShifts < ActiveRecord::Migration[4.2]
  def self.up
    add_column :shifts, :description, :string
  end

  def self.down
    remove_column :shifts, :description
  end
end
