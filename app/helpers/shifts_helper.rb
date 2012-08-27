module ShiftsHelper
  def can_primary?(shift)
    return false if current_user.disabled && !shift.shift_type.ignore_suspended
    return false if over_hours(shift) && !critical(shift)
	  return false if shift.primary != nil
    return false if !current_user.primary unless shift.shift_type.ignore_primary
    return false if conflict(shift)
    return true
	end

	def can_secondary?(shift)
	  return false if over_hours(shift) && !critical(shift)
	  return false if current_user.primary unless (critical(shift) || shift.shift_type.ignore_primary)
	  return false if current_user.disabled && !shift.shift_type.ignore_suspended
	  return false if shift.secondary != nil
    return false if conflict(shift)
    return true
	end
	
	def conflict(shift)
	  current_user.shifts.each do |compare|
	    if shift.start < compare.finish && shift.finish > compare.start
	      return true
	    end
	  end
	  return false
	end

	def critical(shift)
	  shift.start - Time.zone.now < shift.critical_days
	end

	def over_hours(shift)
	  current_user.total_hours(shift.shift_type) >= current_user.hours_quota(shift.shift_type)
	end
end
