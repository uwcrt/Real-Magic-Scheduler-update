class UsersController < ApplicationController
	before_filter :authenticate, :only => [:edit, :update]
	before_filter :correct_user, :only => [:edit, :update]

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
	  @title = "Users"
	end

	private
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless @user == current_user
		end
end
