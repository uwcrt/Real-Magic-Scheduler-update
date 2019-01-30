class AddAwardToUser < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :award, :boolean, :default => false
  end

  def self.down
    remove_column :users, :award
  end
end
