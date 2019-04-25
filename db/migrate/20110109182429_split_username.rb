class SplitUsername < ActiveRecord::Migration[4.2]
  def self.up
    change_table :users do |t|
      t.rename :name, :first_name
      t.string :last_name
    end
  end

  def self.down
    change_table :users do |t|
      t.rename :first_name, :name
      t.remove :last_name
    end
  end
end
