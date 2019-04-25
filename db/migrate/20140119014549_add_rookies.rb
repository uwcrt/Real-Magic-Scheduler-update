class AddRookies < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :position, :integer, :default => 0
    add_column :shifts, :rookie_id, :integer
    add_column :shifts, :rookie_disabled, :boolean, :default => true

    User.all.each do |u|
      u.position = u.primary ? 2 : 1
      u.save
    end

    remove_column :users, :primary
  end

  def self.down
    add_column :users, :primary, :boolean, :default => false

    User.all.each do |u|
      u.primary = u.position == 2
      u.save
    end

    remove_column :users, :position
    remove_column :shifts, :rookie_id, :integer
    remove_column :shifts, :rookie_disabled
  end
end
