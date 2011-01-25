class ShiftsController < ApplicationController
  include ShiftsHelper
  before_filter :authenticate
  before_filter :admin, :only => [:new, :create, :drop_primary, :drop_secondary]
  
  def index
    @title = "Shifts"
    @shifts = admin? ? Shift.all : Shift.current
  end
  
  def new
    @title = "New Shift"
    @shift = Shift.new
  end
  
  def create
		@shift = Shift.new(params[:shift])
		if @shift.save
			flash[:success] = "Shift created successfully!"
			redirect_to shifts_path
		else
			@title = "New Shift"
			render 'new'
		end
	end
	
	def secondary
	  shift = Shift.find(params[:id])
	  if can_secondary?(shift)
	    shift.secondary = current_user
	    shift.save
	    flash[:success] = "You are now the secondary for #{shift.name}"
	  else
	    flash[:error] = "There was a problem processing your request. If this problem continues please contact the scheduler."
	  end
	  redirect_to shifts_path
	end
	
	def primary
	  shift = Shift.find(params[:id])
	  if can_primary?(shift)
	    shift.primary = current_user
	    shift.save
	    flash[:success] = "You are now the primary for #{shift.name}"
	  else
	    flash[:error] = "There was a problem processing your request. If this problem continues please contact the scheduler."
	  end
	  redirect_to shifts_path
	end
	
	def drop_primary
	  shift = Shift.find(params[:id])
	  shift.primary = nil
	  shift.save
	  redirect_to shifts_path
	end
	
	def drop_secondary
	  shift = Shift.find(params[:id])
	  shift.secondary = nil
	  shift.save
	  redirect_to shifts_path
	end
end