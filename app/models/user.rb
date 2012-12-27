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
  devise :cas_authenticatable
  before_save :downcase_username!

  attr_accessible :first_name, :last_name, :username

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :username, :presence => true

  has_many :shifts, :class_name => "Shift", :finder_sql => 'SELECT * FROM shifts WHERE shifts.primary_id = #{id} OR shifts.secondary_id = #{id} ORDER BY shifts.start'

  default_scope :order => 'users.last_name ASC'

  def full_name
    "#{first_name} #{last_name}"
  end

  def name
    "#{first_name} #{last_name[0,1]}."
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

  def downcase_username!
    username.downcase!
  end
end
