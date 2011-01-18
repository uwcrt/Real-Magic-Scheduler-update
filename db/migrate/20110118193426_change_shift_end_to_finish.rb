class ChangeShiftEndToFinish < ActiveRecord::Migration
  def self.up
    change_table :shifts do |t|
      t.rename :end, :finish
    end
  end

  def self.down
    change_table :shifts do |t|
      t.rename :finish, :end
    end
  end
end
