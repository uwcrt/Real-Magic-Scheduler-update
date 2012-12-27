# == Schema Information
# Schema version: 20110222181535
#
# Table name: shifts
#
#  id            :integer         primary key
#  name          :string(255)
#  start         :timestamp
#  finish        :timestamp
#  location      :string(255)
#  primary_id    :integer
#  secondary_id  :integer
#  shift_type_id :integer
#  note          :string(255)
#  created_at    :timestamp
#  updated_at    :timestamp
#  description   :string(255)
#

class Shift < ActiveRecord::Base
  attr_accessible :name, :start, :finish, :location, :shift_type_id, :note, :description, :primary_id, :secondary_id, :aed, :vest, :primary_disabled, :secondary_disabled

  default_scope :order => 'shifts.start ASC'

  validates_presence_of :name, :start, :finish, :location, :shift_type_id
  validates_numericality_of :shift_type_id
  validate :primary_cannot_equal_secondary, :secondary_cannot_take_primary, :finish_after_start

  before_save :remove_from_disabled

  belongs_to :primary, :class_name => "User", :foreign_key => "primary_id"
  belongs_to :secondary, :class_name => "User", :foreign_key => "secondary_id"
  belongs_to :shift_type

  def self.current
    Shift.where("start >= ?", Time.zone.now)
  end

  def self.past
    Shift.where("start < ?", Time.zone.now)
  end

  def self.available
    (Shift.where({:primary_id => nil, :primary_disabled => false}) +
      Shift.where({:secondary_id => nil, :secondary_disabled => false}) -
      past
     ).uniq.sort {|x,y| x.start <=> y.start }
  end

  def length
    (finish - start)/(1.hour)
  end

  def critical_days
    shift_type.critical_days
  end

  private

    def primary_cannot_equal_secondary
      errors.add(:primary_id, "can't be the same as the Secondary") if
        primary_id != nil && primary_id == secondary_id
    end

    def secondary_cannot_take_primary
      errors.add(:primary_id, "Secondary responders cannot take primary shifts!") if
        primary_id != nil && !primary.primary? && !shift_type.ignore_primary
    end

    def finish_after_start
      if (finish.present? && start.present? && finish < start)
        errors.add(:finish, "The shift cannot finish before it starts!")
      end
    end

    def remove_from_disabled
      self.primary = nil if self.primary_disabled
      self.secondary = nil if self.secondary_disabled
    end
end
