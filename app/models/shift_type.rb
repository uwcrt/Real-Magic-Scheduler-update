# == Schema Information
# Schema version: 20110109195732
#
# Table name: shift_types
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  primary_requirement   :integer
#  secondary_requirement :integer
#  created_at            :datetime
#  updated_at            :datetime
#

class ShiftType < ActiveRecord::Base
  attr_accessible :name, :primary_requirement, :secondary_requirement
  
  validates :name, :presence => true
  validates_numericality_of :primary_requirement, :presence => true, :only_integer => true
  validates_numericality_of :secondary_requirement, :presence => true, :only_integer => true
end
