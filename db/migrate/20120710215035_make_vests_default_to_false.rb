class MakeVestsDefaultToFalse < ActiveRecord::Migration
  def self.up
    change_column_default(:shifts, :vest, false)
  end

  def self.down
    change_column_default(:shifts, :vest, true)
  end
end
