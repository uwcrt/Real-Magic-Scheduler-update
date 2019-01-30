class ChangeDataTypeForShiftDescription < ActiveRecord::Migration[4.2]
  def self.up
    change_table :shifts do |t|
      t.change :description, :text
    end
  end

  def self.down
    change_table :shifts do |t|
      t.change :description, :string
    end
  end
end
