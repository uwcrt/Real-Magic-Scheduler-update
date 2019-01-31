require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :first_name => "Justin",
              :last_name => "Vanderheide",
              :username => "user",
              :password => "foobar",
              :password_confirmation => "foobar"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a first name" do
    no_name_user = User.new(@attr.merge(:first_name => ""))
    no_name_user.should_not be_valid
  end

  it "should require a last name" do
    no_name_user = User.new(@attr.merge(:last_name => ""))
    no_name_user.should_not be_valid
  end

  describe "shift attributes" do

    before(:each) do
      @user = User.create!(@attr)
      @user.position = 2
      @shifttype = create(:shift_type)
      @shift_secondary = create(:shift, :secondary => @user, :start => DateTime.now - 5.days)
      @shift_primary = create(:shift, :primary => @user, :start => DateTime.now - 4.days)
      @shift_neither = create(:shift, :start => DateTime.now - 3.days)
    end

    it "should have a shifts attribute" do
      @user.should respond_to(:shifts)
    end

    it "should contain taken secondary shifts" do
      @user.shifts.should include(@shift_secondary)
    end

    it "should contain taken primary shifts" do
      @user.shifts.should include(@shift_primary)
    end

    it "should not include shifts that don't belong to the user" do
      @user.shifts.should_not include(@shift_neither)
    end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "primary attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to position" do
      @user.should respond_to(:position)
    end

    it "should not be a primary by default" do
      @user.should_not be_primary
    end
  end

  describe "taking shifts" do
    describe "rookie" do
      before do
        @user = create(:user, position: 0)
      end

      it "should not be able to take secondary slot on rookie disable shift" do
        @shift = create(:shift, rookie_disabled: true)
        expect(@user.can_secondary? @shift).to be false
      end
    end
  end
end
