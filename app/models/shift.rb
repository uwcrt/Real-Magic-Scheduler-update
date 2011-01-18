# == Schema Information
# Schema version: 20110118193426
#
# Table name: shifts
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  start         :datetime
#  finish        :datetime
#  location      :string(255)
#  primary_id    :integer
#  secondary_id  :integer
#  shift_type_id :integer
#  note          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Shift < ActiveRecord::Base
  include SessionsHelper
  
  attr_accessible :name, :start, :finish, :location, :shift_type_id, :note
  
  default_scope :order => 'shifts.start ASC'
  
  validates_presence_of :name, :start, :finish, :location, :shift_type_id
  validates_numericality_of :shift_type_id
  validate :primary_cannot_equal_secondary, :secondary_cannot_take_primary
  
  belongs_to :primary, :class_name => "User", :foreign_key => "primary_id"
  belongs_to :secondary, :class_name => "User", :foreign_key => "secondary_id"
  belongs_to :shift_type
  
  def self.current
    Shift.where("start >= ?", DateTime.now - 1.day)
  end
  
  def length
  
  end
  
  private
    
    def primary_cannot_equal_secondary
      errors.add(:primary_id, "can't be the same as the Secondary") if
        primary_id != nil && primary_id == secondary_id
    end
    
    def secondary_cannot_take_primary
      errors.add(:primary_id, "Secondary responders cannot take primary shifts!") if
        primary_id != nil && !primary.primary?
    end
end
