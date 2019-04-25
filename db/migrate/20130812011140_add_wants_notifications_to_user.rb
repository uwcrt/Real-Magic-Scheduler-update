class AddWantsNotificationsToUser < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :wants_notifications, :boolean, :default => false
    add_column :users, :last_notified, :datetime, :default => Time.at(0)
  end

  def self.down
    remove_column :users, :wants_notifications
    remove_column :users, :last_notified
  end
end
