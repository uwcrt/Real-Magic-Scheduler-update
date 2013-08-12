class AddWantsNotificationsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :wants_notifications, :boolean, :default => false
    add_column :users, :last_notified, :datetime, :default => Time.new(1970)
  end

  def self.down
    remove_column :users, :wants_notifications
    remove_column :users, :last_notified
  end
end
