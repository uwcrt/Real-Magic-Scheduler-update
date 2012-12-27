class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin
    authenticate_user!
    redirect_to root_url unless current_user.admin?
  end
end
