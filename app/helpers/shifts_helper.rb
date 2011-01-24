module ShiftsHelper
  def can_primary?(shift)
    return false if over_hours(shift) && !critical(shift)
	  return false if shift.primary != nil
    return false if !current_user.primary unless shift.shift_type.ignore_primary
    return false if shift.secondary == current_user
    return true
	end

	def can_secondary?(shift)
	  return false if over_hours(shift) && !critical(shift)
	  return false if shift.secondary != nil
    return false if shift.primary == current_user
    return true
	end

	def critical(shift)
	  shift.start - DateTime.now < 2.days
	end

	def over_hours(shift)
	  current_user.total_hours(shift.shift_type) >= current_user.hours_quota(shift.shift_type)
	end
end
