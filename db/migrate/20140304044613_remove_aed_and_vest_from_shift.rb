class RemoveAedAndVestFromShift < ActiveRecord::Migration
  def self.up
    Shift.all.each do |shift|
      shift.description += shift.aed ? "\nBring the AED" : "\nDo not bring the AED"
      shift.description += shift.vest ? "\nWear a vest" : "\nDo not wear a vest"
      shift.save
    end

    remove_column :shifts, :aed
    remove_column :shifts, :vest
  end

  def self.down
    add_column :shifts, :aed, :boolean, :default => true
    add_column :shifts, :vest, :boolean, :default => false
  end
end
