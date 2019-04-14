require 'digest'
class User < ActiveRecord::Base
  POSITION_OPTIONS = {'Rookie' => 0, 'Secondary' => 1, 'Primary' => 2}

  before_save :downcase_username!

  devise :cas_authenticatable

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :username, :presence => true
  validates_inclusion_of :position, :in => POSITION_OPTIONS.map {|p| p[1]}

  filterrific(
    default_filter_params: { },
    available_filters: [
      :search_query,
      :sorted_by
    ]
  )

  scope :search_query, ->(query) {
    # Searches the users table on the 'first_name' and 'last_name' columns.
    # Matches using LIKE, automatically appends '%' to each term.
    # LIKE is case INsensitive with MySQL, however it is case
    # sensitive with PostGreSQL. To make it work in both worlds,
    # we downcase everything.
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.tr("*", "%") + "%").gsub(/%+/, "%")
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 2
    where(
      terms.map { |_term|
        "(LOWER(users.first_name) LIKE ? OR LOWER(users.last_name) LIKE ?)"
      }.join(" AND "),
      *terms.map { |e| [e] * num_or_conds }.flatten,
    )
  }

  scope :sorted_by, ->(sort_option) {
    direction = /desc$/.match?(sort_option) ? "desc" : "asc"
    case sort_option.to_s
    when /^first_name/
      order("LOWER(users.first_name) #{direction}")
    when /^position/
      order("users.position #{direction}")
    when /^disabled/
      order("users.disabled #{direction}")
    when /^admin/
      order("users.admin #{direction}")
    when /^cert/
      if direction == "asc"
        User.all.sort_by { |u| u.days_until_cert_expiration }
      else
        User.all.sort_by { |u| u.days_until_cert_expiration }.reverse
      end
    else
      type = ShiftType.find sort_option.to_i
      if direction == "asc"
        User.all.sort_by { |u| u.total_hours(type) }
      else
        User.all.sort_by { |u| u.total_hours(type) }.reverse
      end
    end
  }

  def shifts
    Shift.where("primary_id = ? OR secondary_id = ? OR rookie_id = ?", self.id, self.id, self.id)
  end

  def self.notifiable_of_shift(shift)
    users = User.where(:wants_notifications => true).where('last_notified <= ?', Time.now - 3.hours)
    users.to_a.select! {|user| user.can_primary?(shift) || user.can_secondary?(shift) || user.can_rookie?(shift)}

    return users
  end

  def days_until_cert_expiration
    ([sfa_expiry || Date.today, [hcp_expiry || Date.today, amfr_expiry || Date.today].max || Date.today].min - Date.today).to_i
  end

  def as_json
    {
      :first_name => self.first_name,
      :last_name => self.last_name,
      :position => self.position,
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

  def position_name
    @responder_type = User::POSITION_OPTIONS.to_a[self.position][0]
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
    position == POSITION_OPTIONS['Primary']
  end

  def secondary?
    position == POSITION_OPTIONS['Secondary']
  end

  def rookie?
    position == POSITION_OPTIONS['Rookie']
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
    primary? ? type.primary_requirement : type.secondary_requirement
  end

  def can_take?(shift)
    return false if shift.primary == self || shift.secondary == self || shift.rookie == self
    return false if conflict(shift)
    return false if violates_overwork?(shift)
    return false if self.disabled && !shift.shift_type.ignore_suspended
    return false if shift.start < Time.zone.now
    return false if over_hours(shift.shift_type) && !critical(shift)
    return false if (shift.days_away > days_until_cert_expiration) && !shift.shift_type.ignore_certs
    return true
  end

  def can_primary?(shift)
    return false if shift.primary != nil
    return false if !self.primary? unless shift.shift_type.ignore_primary
    return can_take?(shift)
  end

  def can_secondary?(shift)
    return false if self.primary? unless ((critical(shift) && shift.primary != nil)  || shift.shift_type.ignore_primary)
    return false if shift.secondary != nil
    return false if self.rookie? unless (shift.shift_type.ignore_primary)
    return can_take?(shift)
  end

  def can_rookie?(shift)
    return false if (self.primary? || self.secondary?) unless shift.shift_type.ignore_primary
    return false if shift.rookie != nil
    return can_take?(shift)
  end

  def conflict(shift)
    self.shifts.each do |compare|
      if shift != compare && shift.start < compare.finish && shift.finish > compare.start
        return true
      end
    end
    return false
  end

  def violates_overwork?(shift)
    return true if max_hours(shifts + [shift], 2*24) > 16
    return true if max_hours(shifts + [shift], 7*24) > 40
    return false
  end

  def max_hours(shifts, window)
    shifts = shifts.sort_by{|shift| shift.start}
    first = last = 0
    max_hours = hours_taken = shifts[0].length
    while last < shifts.length - 1 do
      if (shifts[last].finish - shifts[first].start) / 1.hour < window
        last += 1
        hours_taken += shifts[last].length
        if (shifts[last].finish - shifts[first].start) / 1.hour > window
          hours_taken -= (shifts[last].finish - shifts[first].start) / 1.hour - window
        end
      else
        hours_taken -= shifts[first].length
        if (shifts[last].finish - shifts[first].start) / 1.hour > window
          hours_taken += (shifts[last].finish - shifts[first].start) / 1.hour - window
        end
        first += 1
      end

      if hours_taken > max_hours
        max_hours = hours_taken
      end
    end
    return max_hours
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
