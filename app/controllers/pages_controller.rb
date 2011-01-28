class PagesController < ApplicationController
  def home
  	@title = "Home"
  end

  def contact
  	@title = "Contact"
  end

	def about
		@title = "About"
	end
	
	def help
		@title = "Help"
	end
	
	def forgot_password
	  @title = "Password Reset"
	end
end
