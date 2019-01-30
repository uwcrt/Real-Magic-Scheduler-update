class EnableRookieDefault < ActiveRecord::Migration[4.2]
  def self.up
      change_column :shifts, :rookie_disabled, :boolean, :default => false
  end

  def self.down
      change_column :shifts, :rookie_disabled, :boolean, :default => true
  end
end
