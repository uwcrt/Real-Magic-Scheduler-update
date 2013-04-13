class Api::UserController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def show
    render :json => current_user.as_json
  end
end
