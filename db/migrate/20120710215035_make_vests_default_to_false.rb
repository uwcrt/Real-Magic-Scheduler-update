class MakeVestsDefaultToFalse < ActiveRecord::Migration[4.2]
  def self.up
    change_column_default(:shifts, :vest, false)
  end

  def self.down
    change_column_default(:shifts, :vest, true)
  end
end
