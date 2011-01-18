require 'spec_helper'

describe Shift do
  
  before(:each) do
    @attr = { :name => "Example Shift",
              :start => Time.now,
              :finish => Time.now + 5.hours,
              :location => "SLC",
              :shift_type_id => 1,
              :note => "No Booze"}
  end
  
  describe "Validation" do
  
    it "should create a shift given valid options" do
      Shift.create!(@attr)
    end
    
    it "should require a name" do
      @shift = Shift.new(@attr.merge(:name => ""))
      @shift.should_not be_valid
    end
    
    it "should require a start time" do
      @shift = Shift.new(@attr.merge(:start => nil))
      @shift.should_not be_valid
    end
    
    it "should reject invalid start times" do
      @shift = Shift.new(@attr.merge(:start => "fake time"))
      @shift.should_not be_valid
    end
    
    it "should require an end time" do
      @shift = Shift.new(@attr.merge(:finish => nil))
      @shift.should_not be_valid
    end
    
    it "should reject invalid end times" do
      @shift = Shift.new(@attr.merge(:finish => "fake time"))
      @shift.should_not be_valid
    end
    
    it "should require a location" do
      @shift = Shift.new(@attr.merge(:location => ""))
      @shift.should_not be_valid
    end
    
    it "should require a shift type" do
      @shift = Shift.new(@attr.merge(:shift_type_id => nil))
      @shift.should_not be_valid
    end
    
    it "should require a numeric shift type" do
      @shift = Shift.new(@attr.merge(:shift_type_id => "fake"))
      @shift.should_not be_valid
    end
  end
  
  describe "Associations" do
   
    before(:each) do
      @shift = Shift.new(@attr)
    end
   
    it "should have a primary attribute" do
      @shift.should respond_to(:primary)
    end 
    
    it "should have a secondary attribute" do
      @shift.should respond_to(:secondary)
    end
    
    it "should have a shift_type attribute" do
      @shift.should respond_to(:shift_type)
    end
    
    describe "Taking shifts" do
      
      before(:each) do
        @primary = Factory(:user, :primary => true)
        @secondary = Factory(:user, :email => Factory.next(:email))
      end
      
      it "should be store a primary responder" do
        @shift.primary = @primary
        @shift.should be_valid
        @shift.primary.should == @primary
      end
      
      it "should be able to store a secondary responder" do
        @shift.secondary = @secondary
        @shift.should be_valid
        @shift.secondary.should == @secondary
      end
      
      it "should not allow the same person to be both primary and secondary" do
        @shift.primary = @shift.secondary = @primary
        @shift.should_not be_valid
      end
      
      it "should allow two seperate people to be primary and secondary" do
        @shift.primary = @primary
        @shift.secondary = @secondary
        @shift.should be_valid
      end
      
      it "should not let a secondary responder take a primary shift" do
        @shift.primary = @secondary
        @shift.should_not be_valid
      end
    end
  end
end
