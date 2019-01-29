require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do

    before(:each) do
      @user = test_sign_in(create(:user))
    end

    it "should be successful" do
      get :show, params: { id: @user }
      response.should be_success
    end

    it "should find the right user" do
      get :show, params: { id: @user }
      assigns(:user).should == @user
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @user = test_sign_in(create(:user))
      @user.toggle(:admin)
    end

    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = create(:user)
      test_sign_in(@user)
    end
  end

  describe "authentication of edit/update pages" do

    before(:each) do
      @user = create(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, params: { id: @user }
        response.should redirect_to(new_user_session_path)
      end

      it "should deny access to 'update'" do
        put :update, params: { id: @user, user: {} }
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "for wrong users" do

      before(:each) do
       wrong_user = create(:user, :username => "user")
       test_sign_in(wrong_user)
      end

      it "should deny access to 'edit'" do
        get :edit, params: { id: @user }
        response.should redirect_to(root_path)
      end

      it "should deny access to 'update'" do
        put :update, params: { id: @user, user: {} }
        response.should redirect_to(root_path)
      end
    end
  end
end
