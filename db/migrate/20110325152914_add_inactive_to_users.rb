class AddInactiveToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :inactive, :boolean, :default => false
  end

  def self.down
    remove_column :users, :inactive
  end
end
