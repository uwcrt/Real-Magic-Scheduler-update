class UsersController < ApplicationController
  before_action :authenticate_user!, :only => [:edit, :update]
  before_action :correct_user, :only => [:show, :edit, :update]
  before_action :admin, :only => [:edit, :update, :create, :new, :primary, :make_admin, :suspended, :eot, :admin, :destroy, :index]

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "User created successfully!"
      redirect_to new_user_path
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def edit
    @title = "Edit user"
  end

  def destroy
    user = User.find params[:id]
    user.delete
    flash[:success] = "#{user.name} deleted."
    redirect_to users_path
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated."
      redirect_to users_path
    else
      @title = "Edit user"
      @user.password = ""
      @user.password_confirmation = ""
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @past_shifts = @user.past_shifts.sort_by{|s| s.start}
    @current_shifts = @user.current_shifts.sort_by{|s| s.start}
    @shift_types = ShiftType.all

    if @user.disabled
      @responder_type = "Suspended"
    else
      @responder_type = @user.position_name
    end
  end

  def toggle_notifications
    current_user.wants_notifications = !current_user.wants_notifications
    current_user.save

    if (current_user.wants_notifications)
      flash[:success] = "You will now receive notifications for new shifts"
    elsif
      flash[:success] = "You will no longer receive notifications for new shifts"
    end

    redirect_to user_path(current_user)
  end

  def calendar
    @user = User.find(params[:id])
    render plain: @user.calendar
  end

  def index
    @filterrific = initialize_filterrific(
      User,
      params[:filterrific]
    ) or return
    @users = @filterrific.find
    @shift_types = ShiftType.all
    @title = "Users"

    respond_to do |format|
      format.html
      format.js
    end
  end

  def primary
    @user = User.find(params[:id])
    @user.toggle!(:primary)
    respond_to do |format|
      format.html { redirect_to users_path }
      format.js
    end
  end

  def suspended
    @user = User.find(params[:id])
    @user.toggle!(:disabled)
    respond_to do |format|
      format.html { redirect_to users_path }
      format.js
    end
  end

  def make_admin
    @user = User.find(params[:id])
    @user.toggle!(:admin)
    if @user.admin?
      flash[:success] = "#{@user.full_name} is now an administrator!"
    else
      flash[:success] = "#{@user.full_name} is no longer an administrator!"
    end
    redirect_to users_path
  end

  def eot
    @title = "RMS Reset"
    eot_day = Date.civil(params[:eot_date][:year].to_i, params[:eot_date][:month].to_i, params[:eot_date][:day].to_i)
    Shift.where("start < ?", eot_day).delete_all
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :wants_notifications, :last_notified, :bls_expiry, :sfa_expiry, :fr_expiry, :position)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless @user == current_user || current_user.admin?
    end
end
