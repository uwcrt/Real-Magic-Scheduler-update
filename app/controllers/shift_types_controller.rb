class ShiftTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin

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

  def naughty
    @filterrific = initialize_filterrific(
      User,
      params[:filterrific]
    ) or return
    @type = ShiftType.find_by_id(params[:id])
    @title = @type.name + " Naughty List"
    @users = @filterrific.find.reject{|n| n.disabled}
    @users.reject! {|n| n.total_hours(@type) >= n.hours_quota(@type)}
    @type = [@type]
  end

  def update
    @type = ShiftType.find_by_id(params[:id])
    if @type.update_attributes(shift_type_params)
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
    redirect_to shift_types_path
  end

  def create
    @type = ShiftType.new(shift_type_params)
    if @type.save
      flash[:success] = "Shift typed created successfully!"
      redirect_to shift_types_path
    else
      @title = "New Shift Type"
      render 'new'
    end
  end

  def make_default
    @type = ShiftType.find_by_id(params[:id])
    @type.make_default
    @type.save

    @title = "Shift Types"
    @types = ShiftType.all
    render 'index'
  end

  private
    def shift_type_params
      params.require(:shift_type).permit(:name, :primary_requirement, :secondary_requirement, :ignore_primary, :ignore_suspended, :critical_time, :ignore_certs)
    end
end
