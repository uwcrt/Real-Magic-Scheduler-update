class DropAwardAndInactiveFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :inactive
    remove_column :users, :award
  end

  def self.down
    add_column :users, :inactive, :boolean, :default => false
    add_column :users, :award, :boolean, :default => false
  end
end
