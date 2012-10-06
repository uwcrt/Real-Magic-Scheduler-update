class AddUsernameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, :null => false, :default => ""
    add_index :users, :username
  end

  def self.down
    remove_column :users, :username
  end
end
