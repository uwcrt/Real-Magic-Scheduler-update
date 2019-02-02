require 'spec_helper'
require 'database_cleaner'

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

    describe "overwork policy" do
      before(:each) do
        DatabaseCleaner.clean
        @shift = build(:shift, start: Time.current + 1.hour)
        @user = create(:user, sfa_expiry: Time.current + 1.year, hcp_expiry: Time.current + 1.year)
      end

      it "should allow taking a shift" do
        expect(@user.can_take? @shift).to be true
      end

      it "should not allow taking over 16 hours of shift within 48 hours" do
        create(:shift, start: Time.current + 10.hour, finish: Time.current + 23.hours)
        expect(@user.can_take? @shift).to be false
      end

      it "should allow taking 16 hours of shift over more than 48 hours" do
        create(:shift, start: Time.current + 38.hour, finish: Time.current + 51.hours)
        expect(@user.can_take? @shift).to be true
      end

      it "should allow taking exactly 16 hours of shift in 48 hours" do
        create(:shift, start: Time.current + 37.hour, finish: Time.current + 59.hours)
        expect(@user.can_take? @shift).to be true
      end

      it "should not allow taking over 40 hours of shift within 7 days" do
        create(:shift, start: Time.current + 10.hour, finish: Time.current + 47.hours)
        expect(@user.can_take? @shift).to be false
      end

      it "should allow taking over 40 hours of shift over more than 7 days" do
        create(:shift, start: Time.current + 150.hour, finish: Time.current + 187.hours)
        expect(@user.can_take? @shift).to be true
      end

      it "should allow taking exactly 40 hours of shift in 7 days" do
        create(:shift, start: Time.current + 133.hour, finish: Time.current + 169.hours)
        expect(@user.can_take? @shift).to be true
      end

      describe "max hours in" do
        before(:each) do
          @shifts = [
            build(:shift, start: Time.current, finish: Time.current + 2.hour),
            build(:shift, start: Time.current + 4.hour, finish: Time.current + 8.hour),
            build(:shift, start: Time.current + 9.hour, finish: Time.current + 11.hour),
            build(:shift, start: Time.current + 13.5.hour, finish: Time.current + 17.5.hour)
          ]
        end

        it "8 hours should be 6" do
          expect(@user.max_hours(@shifts, 8)).to be_within(0.000001).of 6
        end

        it "2 hours should be 2" do
          expect(@user.max_hours(@shifts, 2)).to be_within(0.000001).of 2
        end

        it "10 hours should be 7" do
          expect(@user.max_hours(@shifts, 10)).to be_within(0.000001).of 7
        end
      end
    end
  end
end
