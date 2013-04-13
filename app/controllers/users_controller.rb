class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update]
  before_filter :correct_user, :only => [:show, :edit, :update]
  before_filter :admin, :only => [:edit, :update, :create, :new, :primary, :make_admin, :suspended, :eot, :admin, :destroy, :index]

  def create
    @user = User.new(params[:user])

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
    if @user.update_attributes(params[:user])
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
    @past_shifts = @user.past_shifts
    @current_shifts = @user.current_shifts
    @shift_types = ShiftType.all

    if @user.disabled
      @responder_type = "Suspended"
    elsif @user.primary
      @responder_type = "Primary"
    else
      @responder_type = "Secondary"
    end
  end

  def index
    @users = User.all
    @shift_types = ShiftType.all
    @title = "Users"
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

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless @user == current_user || current_user.admin?
    end
end
