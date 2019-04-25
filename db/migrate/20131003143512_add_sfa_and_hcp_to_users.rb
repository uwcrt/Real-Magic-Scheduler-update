class AddSfaAndHcpToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :sfa_expiry, :date, :default => Date.new(1)
    add_column :users, :hcp_expiry, :date, :default => Date.new(1)
  end

  def self.down
    remove_column :users, :sfa_expiry
    remove_column :users, :hcp_expiry
  end
end
