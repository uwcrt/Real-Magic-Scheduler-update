# == Schema Information
# Schema version: 20110222181535
#
# Table name: shift_types
#
#  id                    :integer         primary key
#  name                  :string(255)
#  primary_requirement   :integer
#  secondary_requirement :integer
#  created_at            :timestamp
#  updated_at            :timestamp
#  ignore_primary        :boolean
#

class ShiftType < ActiveRecord::Base
  attr_accessible :name, :primary_requirement, :secondary_requirement, :ignore_primary, :ignore_suspended, :critical_time
  
  validates :name, :presence => true
  validates_numericality_of :primary_requirement, :presence => true
  validates_numericality_of :secondary_requirement, :presence => true
  validates_numericality_of :critical_time, :presence => true, :greater_than_or_equal_to => 0

  def critical_days
    critical_time * 1.day
  end
end
