class AddAwardToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :award, :boolean, :default => false
  end

  def self.down
    remove_column :users, :award
  end
end
