class AddUsernameToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :username, :string, :null => false, :default => ""
    add_index :users, :username
  end

  def self.down
    remove_column :users, :username
  end
end
