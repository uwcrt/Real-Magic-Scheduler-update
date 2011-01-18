require 'spec_helper'

describe ShiftsController do
  render_views

  describe "Authentication" do
    describe "Not logged in" do

      it "should redirect the 'new' page to the login page" do
        get :new
        response.should redirect_to(signin_path)
      end

      it "should redirect the 'index' page to the login page" do
        get :index
        response.should redirect_to(signin_path)
      end

      it "should redirect the 'create' action to the login page" do
        post :create
        response.should redirect_to(signin_path)
      end
    end

    describe "Logged in as a regular user" do

      before(:each) do
        test_sign_in(Factory(:user))
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
        test_sign_in(Factory(:user)).toggle!(:admin)
      end

      it "should render the 'new' page" do
        get :new
        response.should be_successful
      end
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    it "should be successful" do
      get :index
      response.should be_successful
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "Shifts")
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @user.toggle!(:admin)
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
    	get :new
    	response.should have_selector("title", :content => "New Shift")
    end

    it "should have a name field" do
      get :new
      response.should have_selector("input[name='shift[name]'][type='text']")
    end

    it "should have a location field" do
      get :new
      response.should have_selector("input[name='shift[location]'][type='text']")
    end

    it "should have a start field" do
      get :new
      response.should have_selector("label[for='shift_start']")
    end

    it "should have a finish field" do
      get :new
      response.should have_selector("label[for='shift_finish']")
    end

    it "should have a note field" do
      get :new
      response.should have_selector("input[name='shift[note]'][type='text']")
    end

    it "should have a link back to the index" do
      get :new
      response.should have_selector("a", :href => shifts_path, :content => "Back")
    end

    it "should have a submit button" do
      get :new
      response.should have_selector("input", :type => "submit", :value => "Create")
    end
  end
end
