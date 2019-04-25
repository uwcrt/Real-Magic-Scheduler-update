class Api::UserController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def show
    render :json => current_user.as_json
  end
end
