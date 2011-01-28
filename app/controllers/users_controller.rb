class UsersController < ApplicationController
	before_filter :authenticate, :only => [:edit, :update]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin, :only => [:create, :new, :primary, :suspended]

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "User created successfully!"
			redirect_to new_user_path
		else
			@title = "Sign up"
			@user.password = ""
			@user.password_confirmation = ""
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

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated."
			redirect_to @user
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
	
	def reset
	  user = User.find_by_email params[:email]
	  if user == nil 
	    flash[:error] = "The email address you provided is not associated with an account."
			redirect_to forgot_password_path
		else
	    password = ("a".."z").to_a.shuffle[0..5].to_s
	    user.password = password
	    user.password_confirmation = password
	    user.save
	    UserMailer.password_reset_email(user, password).deliver
	    flash[:success] = "Your password has been reset, and your new password has been emailed to you."
	    redirect_to signin_path
	  end
	end
	
	def primary
	  @user = User.find(params[:id])
	  @user.toggle!(:primary)
	  redirect_to users_path
	end
  
  def suspended
	  @user = User.find(params[:id])
	  @user.toggle!(:disabled)
	  redirect_to users_path
	end
	
	private
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless @user == current_user
		end
end
