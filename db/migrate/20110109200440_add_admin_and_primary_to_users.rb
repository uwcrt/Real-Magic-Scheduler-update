class AddAdminAndPrimaryToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :primary, :boolean, :default => false
  end

  def self.down
    remove_column :users, :primary
    remove_column :users, :admin
  end
end
