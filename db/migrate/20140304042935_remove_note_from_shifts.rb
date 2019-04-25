class RemoveNoteFromShifts < ActiveRecord::Migration[4.2]
  def self.up
    Shift.all.each do |shift|
      shift.description = shift.description.to_s + "\n" + shift.note.to_s
      shift.save
    end

    remove_column :shifts, :note
  end

  def self.down
    add_column :shifts, :note, :string
  end
end
