class AddAmfrExpiryToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :amfr_expiry, :date, :default => Date.new(1)
  end

  def self.down
    remove_column :users, :amfr_expiry
  end
end