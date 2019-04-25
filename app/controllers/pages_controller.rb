class PagesController < ApplicationController
  before_action :admin, :only => [:eot]

  def home
    redirect_to shifts_path if signed_in?
    @title = "Home"
  end

  def eot
    @title = "End of Term"
  end
end
