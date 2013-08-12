# == Schema Information
# Schema version: 20110222181535
#
# Table name: users
#
#  id                 :integer         primary key
#  first_name         :string(255)
#  email              :string(255)
#  created_at         :timestamp
#  updated_at         :timestamp
#  encrypted_password :string(255)
#  salt               :string(255)
#  last_name          :string(255)
#  admin              :boolean
#  primary            :boolean
#  disabled           :boolean
#

require 'digest'
class User < ActiveRecord::Base
  devise :cas_authenticatable,
         :token_authenticatable

  before_save :downcase_username!, :ensure_authentication_token

  attr_accessible :first_name, :last_name, :username, :wants_notifications

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :username, :presence => true

  has_many :shifts, :class_name => "Shift", :finder_sql => 'SELECT * FROM shifts WHERE shifts.primary_id = #{id} OR shifts.secondary_id = #{id} ORDER BY shifts.start'

  default_scope :order => 'users.last_name ASC'

  def self.notifiable_of_shift(shift)
    users = User.where(:wants_notifications => true, :disabled => false).where('last_notified <= ?', Time.now - 3.hours);
    users.to_a.select! {|user| user.can_primary?(shift) || user.can_secondary?(shift)}

    return users
  end
  
  def as_json
    {
      :first_name => self.first_name,
      :last_name => self.last_name,
      :primary => self.primary,
      :suspended => self.disabled,
      :shifts => self.shifts.as_json(self),
      :shift_types => ShiftType.all.as_json(self)
    }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def name
    "#{first_name} #{last_name[0,1]}."
  end

  def calendar
    RiCal.Calendar do |cal|
      self.shifts.each do |shift|
        cal.event do |event|
          event.dtstart = shift.start
          event.dtend = shift.finish
          event.summary = shift.name
          event.uid = "#{ENV['URL']}/shifts/#{shift.id}"
          event.dtstamp = shift.created_at
          event.description = shift.description
          event.alarm do |alarm|
            alarm.action = "DISPLAY"
            alarm.trigger = "-PT1H"
          end
        end
      end
    end
  end

  def admin?
    admin
  end

  def primary?
    primary
  end

  def past_shifts
    shifts.select { |shift| shift.start <= Time.zone.now }
  end

  def current_shifts
    shifts.select { |shift| shift.start > Time.zone.now }
  end

  def hours(type)
    past_shifts.inject(0){|sum, shift| shift.shift_type == type ? sum + shift.length : sum}
  end

  def upcoming_hours(type)
    current_shifts.inject(0){|sum, shift| shift.shift_type == type ? sum + shift.length : sum}
  end

  def total_hours(type)
    hours(type) + upcoming_hours(type)
  end

  def hours_quota(type)
    primary ? type.primary_requirement : type.secondary_requirement
  end

  def can_primary?(shift)
    return false if shift.start < Time.zone.now
    return false if self.disabled && !shift.shift_type.ignore_suspended
    return false if over_hours(shift.shift_type) && !critical(shift)
    return false if shift.primary != nil
    return false if !self.primary unless shift.shift_type.ignore_primary
    return false if conflict(shift)
    return true
  end

  def can_secondary?(shift)
    return false if shift.start < Time.zone.now
    return false if over_hours(shift.shift_type) && !critical(shift)
    return false if self.primary unless (critical(shift) || shift.shift_type.ignore_primary)
    return false if self.disabled && !shift.shift_type.ignore_suspended
    return false if shift.secondary != nil
    return false if conflict(shift)
    return true
  end

  def conflict(shift)
    self.shifts.each do |compare|
      if shift.start < compare.finish && shift.finish > compare.start
        return true
      end
    end
    return false
  end

  def critical(shift)
    shift.start - Time.zone.now < shift.critical_days
  end

  def over_hours(shift_type)
    self.total_hours(shift_type) >= self.hours_quota(shift_type)
  end

  def downcase_username!
    username.downcase!
  end

  def email
    "#{username}@uwaterloo.ca"
  end
end
