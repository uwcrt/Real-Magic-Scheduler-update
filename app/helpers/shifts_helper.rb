module ShiftsHelper
  def can_primary?(shift)
	  return false if shift.primary != nil
    return false if !current_user.primary
    return false if shift.secondary == current_user
    return true
	end  
	
	def can_secondary?(shift)
	  return false if shift.secondary != nil
    return false if shift.primary == current_user
    return true
	end  
end
