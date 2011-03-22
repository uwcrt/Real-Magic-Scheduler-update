class ChangeDataTypeForShiftQuota < ActiveRecord::Migration
  def self.up
    change_table :shift_types do |t|
      t.change :primary_requirement, :float
      t.change :secondary_requirement, :float
    end
  end

  def self.down
    change_table :shifts do |t|
      t.change :primary_requirement, :integer
      t.change :secondary_requirement, :integer
    end
  end
end
