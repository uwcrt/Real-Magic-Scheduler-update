class Shift < ActiveRecord::Base
  attr_accessible :name, :start, :finish, :location, :shift_type_id, :description, :primary_id, :secondary_id, :rookie_id, :primary_disabled, :secondary_disabled, :rookie_disabled


  validates_presence_of :name, :start, :finish, :location, :shift_type_id
  validates_numericality_of :shift_type_id
  validate :unique_responders, :secondary_cannot_take_primary, :finish_after_start

  before_save :remove_from_disabled, :notify_responders

  belongs_to :primary, :class_name => "User", :foreign_key => "primary_id"
  belongs_to :secondary, :class_name => "User", :foreign_key => "secondary_id"
  belongs_to :rookie, :class_name => "User", :foreign_key => "rookie_id"
  belongs_to :shift_type

  def self.current
    Shift.where("start >= ?", Time.zone.now - 1.day)
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

  def as_json(user = nil)
    json = {
      :id => self.id,
      :start => self.start,
      :finish => self.finish,
      :description => self.description,
      :primary_disabled => self.primary_disabled,
      :secondary_disabled => self.secondary_disabled,
      :rookie_disabled => self.rookie_disabled,
      :primary => self.primary.try(:full_name),
      :secondary => self.secondary.try(:full_name),
      :rookie => self.rookie.try(:full_name),
      :shift_type => self.shift_type.name,
      :duration => self.length
    }

    unless user.nil?
      json[:can_primary] = user.can_primary?(self)
      json[:can_secondary] = user.can_secondary?(self)
    end

    return json
  end

  def days_away
    ((finish - DateTime.now) / 1.day).ceil
  end

  def length
    (finish - start)/(1.hour)
  end

  def critical_days
    shift_type.critical_days
  end

  def notify_responders
    if (self.new_record?)
      users = User.notifiable_of_shift(self).to_a
      ShiftMailer.new_email(self, users).deliver if users.any?
    elsif (self.location_changed? || self.start_changed? || self.finish_changed? || self.name_changed?)
      users_to_notify = [self.primary, self.secondary].compact
      ShiftMailer.update_email(self, users_to_notify).deliver if users_to_notify.any?
    end
  end

  def split!(split_length)
    start = self.start
    finish = self.finish

    num_shifts = (self.length.hours) / split_length
    shift = self

    (0...num_shifts).each do |n|
      shift.start = start + split_length * n
      shift.finish = [shift.start + split_length, finish].min
      shift.save
      shift = self.clone
    end
  end

  private

    def unique_responders
      errors.add(:primary_id, "can't be the same as the Secondary") if
        primary_id != nil && primary_id == secondary_id
      errors.add(:secondary_id, "can't be the same as the Rookie") if
        secondary_id != nil && secondary_id == rookie_id
      errors.add(:rookie_id, "can't be the same as the Primary") if
        rookie_id != nil && rookie_id == primary_id
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
      self.rookie = nil if self.rookie_disabled
    end
end
