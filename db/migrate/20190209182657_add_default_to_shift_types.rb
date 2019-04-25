class AddDefaultToShiftTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :shift_types, :default, :boolean, default: false
  end
end
