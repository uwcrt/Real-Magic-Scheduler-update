class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  def authenticate
		deny_access unless signed_in?
	end
	
	def admin
	  redirect_to(root_path) unless admin?
	end
end
