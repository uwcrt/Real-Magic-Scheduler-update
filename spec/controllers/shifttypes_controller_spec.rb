require 'spec_helper'

describe ShiftTypesController do
  render_views

  describe "GET 'new'" do
    describe "Not logged in" do
      it "should redirect to te login path" do
        get :new
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "not an administrator" do

      before(:each) do
        test_sign_in(create(:user))
      end
      it "should redirect to the home page" do
        get :new
        response.should redirect_to(root_path)
      end
    end

    describe "as an administrator" do
      before(:each) do
        test_sign_in(create(:user)).toggle!(:admin)
      end
      it 'should be successfull' do
        get :new
        response.should be_successful
      end
    end
  end

  describe "GET 'index'" do

    describe "Not logged in" do

      it "should redirect to the login page" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "Not an administrator" do

      before(:each) do
        @user = test_sign_in(create(:user))
      end

      it "should redirect to the home page" do
        get :index
        response.should redirect_to(root_path)
      end
    end

    describe "as an administrator" do
      before (:each) do
        test_sign_in(create(:user)).toggle!(:admin)
      end

      it "should be successful" do
        get :index
        response.should be_successful
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      test_sign_in(create(:user)).toggle!(:admin)
    end
    describe "failure" do

      before(:each) do
        @attr = { :name => "", :primary_requirement => "", :secondary_requirement => ""}
      end

      it "should not create a type" do
        lambda do
          post :create, :shift_type => @attr
        end.should_not change(ShiftType, :count)
      end

      it "should render the 'new' page" do
        post :create, :shift_type => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "Justin",
                  :primary_requirement => 25,
                  :secondary_requirement => 25 }
      end

      it "should create a type" do
        lambda do
          post :create, :shift_type => @attr
        end.should change(ShiftType, :count).by(1)
      end

      it "should show the types index" do
        post :create, :shift_type => @attr
        response.should redirect_to shift_types_path
      end
    end
  end
end
