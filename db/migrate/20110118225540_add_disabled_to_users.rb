class AddDisabledToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :disabled, :boolean, :default => false
  end

  def self.down
    remove_column :users, :disabled
  end
end
