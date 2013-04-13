class Api::TokensController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def show
    @user = current_user
  end
end
