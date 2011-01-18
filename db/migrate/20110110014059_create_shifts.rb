class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.string :location
      t.integer :primary_id
      t.integer :secondary_id
      t.integer :shift_type_id
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :shifts
  end
end
