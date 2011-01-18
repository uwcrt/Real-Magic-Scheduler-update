class ShiftTypesController < ApplicationController
  before_filter :authenticate
  before_filter :admin

  def index
    @title = "Shift Types"
    @types = ShiftType.all
  end
  
  def new
    @title = "New Shift Type"
    @type = ShiftType.new()
  end
  
  def edit
    @title = "Update Shift Type"
    @type = ShiftType.find_by_id(params[:id])
  end
  
  def update
		@type = ShiftType.find_by_id(params[:id])
		if @type.update_attributes(params[:shift_type])
			flash[:success] = "Shift type updated successfully!"
			redirect_to shift_types_path
		else
			@title = "Edit Shift Type"
			render 'edit'
		end
	end
  
  def destroy
    @type = ShiftType.find_by_id(params[:id])
    flash[:success] = "#{@type.name} deleted successfully!"
    @type.destroy
    redirect_back_or shift_types_path
  end
  
  def create
		@type = ShiftType.new(params[:shift_type])
		if @type.save
			flash[:success] = "Shift typed created successfully!"
			redirect_to shift_types_path
		else
			@title = "New Shift Type"
			render 'new'
		end
	end
end
