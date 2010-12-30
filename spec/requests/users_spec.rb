require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
      	lambda  do
		      visit root_path
		      click_link "Sign up"
		      fill_in "Name",         :with => ""
		      fill_in "Email",        :with => "fakeemail"
		      fill_in "Password",     :with => "foobar"
		      fill_in "Confirmation", :with => "foobar"
		      click_button
		      response.should render_template('users/new')
		      response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
      
      it "should make a new user" do
      	lambda  do
		      visit root_path
		      click_link "Sign up"
		      fill_in "Name",         :with => "Example User"
		      fill_in "Email",        :with => "user@example.com"
		      fill_in "Password",     :with => "foobar"
		      fill_in "Confirmation", :with => "foobar"
		      click_button
		      response.should render_template('users/show')
		      response.should have_selector("div.flash.success", :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe "sign in/out" do
  	it "should not log in" do
  		visit root_path
  		click_link "Sign in"
  		fill_in :email,			:with => ""
  		fill_in	:password,	:with => ""
  		click_button
  		response.should have_selector("div.flash.error", :content => "invalid")
  	end
  	
  	it "should log in and out" do
  		integration_sign_in Factory(:user)
  		controller.should be_signed_in
  		click_link "Sign out"
  		controller.should_not be_signed_in
  	end
  end
end

