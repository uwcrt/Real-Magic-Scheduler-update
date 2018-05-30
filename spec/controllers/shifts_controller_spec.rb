require 'spec_helper'

describe ShiftsController do
  render_views

  describe "Authentication" do
    describe "Not logged in" do

      it "should redirect the 'new' page to the login page" do
       get :new
        response.should redirect_to(new_user_session_path)
      end

      it "should redirect the 'index' page to the login page" do
        get :index
        response.should redirect_to(new_user_session_path)
      end

      it "should redirect the 'create' action to the login page" do
        post :create
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "Logged in as a regular user" do

      before(:each) do
        test_sign_in(create(:user))
      end

      it "should redirect the 'new' page to the root path" do
        get :new
        response.should redirect_to(root_path)
      end

      it "should render the 'index' page" do
        get :index
        response.should be_successful
      end

      it "should redirect the 'create' action to the root path" do
        post :create
        response.should redirect_to(root_path)
      end
    end

    describe "Logged in as an adminstrator" do

      before(:each) do
        test_sign_in(create(:user)).toggle!(:admin)
      end

      it "should render the 'new' page" do
        get :new
        response.should be_successful
      end
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = test_sign_in(create(:user))
    end

    it "should be successful" do
      get :index
      response.should be_successful
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @user = test_sign_in(create(:user))
      @user.toggle!(:admin)
    end

    it "should be successful" do
      get :new
      response.should be_success
    end
  end
end
