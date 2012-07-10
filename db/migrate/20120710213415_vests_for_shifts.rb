class VestsForShifts < ActiveRecord::Migration
  def self.up
    add_column :shifts, :vest, :boolean, :default => true
    Shift.all.each do |shift|
      shift.vest = false
      shift.save
    end
  end

  def self.down
    remove_column :shifts, :vest
  end
end
