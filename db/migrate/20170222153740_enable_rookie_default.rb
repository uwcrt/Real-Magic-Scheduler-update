class EnableRookieDefault < ActiveRecord::Migration
  def self.up
      change_column :shifts, :rookie_disabled, :boolean, :default => false
  end

  def self.down
      change_column :shifts, :rookie_disabled, :boolean, :default => true
  end
end