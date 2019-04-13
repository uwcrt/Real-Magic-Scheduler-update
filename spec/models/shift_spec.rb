require 'spec_helper'

describe Shift do

  before(:each) do
    @attr = { :name => "Example Shift",
              :start => Time.now,
              :finish => Time.now + 5.hours,
              :location => "SLC",
              :shift_type_id => 1}
  end

  describe "Validation" do

    it "should create a shift given valid options" do
      Shift.create!(@attr)
    end

    it "should require a name" do
      @shift = Shift.new(@attr.merge(:name => ""))
      expect(@shift).not_to be_valid
    end

    it "should require a start time" do
      @shift = Shift.new(@attr.merge(:start => nil))
      expect(@shift).not_to be_valid
    end

    it "should reject invalid start times" do
      @shift = Shift.new(@attr.merge(:start => "fake time"))
      expect(@shift).not_to be_valid
    end

    it "should require an end time" do
      @shift = Shift.new(@attr.merge(:finish => nil))
      expect(@shift).not_to be_valid
    end

    it "should reject invalid end times" do
      @shift = Shift.new(@attr.merge(:finish => "fake time"))
      expect(@shift).not_to be_valid
    end

    it "should require a location" do
      @shift = Shift.new(@attr.merge(:location => ""))
      expect(@shift).not_to be_valid
    end

    it "should require a shift type" do
      @shift = Shift.new(@attr.merge(:shift_type_id => nil))
      expect(@shift).not_to be_valid
    end

    it "should require a numeric shift type" do
      @shift = Shift.new(@attr.merge(:shift_type_id => "fake"))
      expect(@shift).not_to be_valid
    end
  end

  describe "Defaults" do
    before(:each) do
      @shift = Shift.new(@attr)
    end

    it "primary slot should be enabled by default" do
      expect(@shift.primary_disabled).to be false
    end

    it "secondary slot should be enabled by default" do
      expect(@shift.secondary_disabled).to be false
    end

    it "rookie slot should be enabled by default" do
      expect(@shift.rookie_disabled).to be false
    end
  end

  describe "Associations" do

    before(:each) do
      @shift = Shift.new(@attr)
    end

    it "should have a primary attribute" do
      expect(@shift).to respond_to(:primary)
    end

    it "should have a secondary attribute" do
      expect(@shift).to respond_to(:secondary)
    end

    it "should have a rookie attribute" do
      expect(@shift).to respond_to(:rookie)
    end

    it "should have a shift_type attribute" do
      expect(@shift).to respond_to(:shift_type)
    end

    describe "Taking shifts" do

      before(:each) do
        @primary = create(:user, :position => 2)
        @secondary = create(:user, :position => 1)
        @rookie = create(:user, :position => 0)
      end

      it "should be store a primary responder" do
        @shift.primary = @primary
        expect(@shift).to be_valid
        expect(@shift.primary).to eq(@primary)
      end

      it "should be able to store a secondary responder" do
        @shift.secondary = @secondary
        expect(@shift).to be_valid
        expect(@shift.secondary).to eq(@secondary)
      end

      it "should be able to store a rookie responder" do
        @shift.rookie = @rookie
        expect(@shift).to be_valid
        expect(@shift.rookie).to eq(@rookie)
      end

      it "should not allow the same person to be both primary and secondary" do
        @shift.primary = @shift.secondary = @primary
        expect(@shift).not_to be_valid
      end

      it "should not allow the same person to be both rookie and secondary" do
        @shift.rookie = @shift.secondary = @primary
        expect(@shift).not_to be_valid
      end


      it "should not allow the same person to be both primary and rookie" do
        @shift.primary = @shift.rookie = @primary
        expect(@shift).not_to be_valid
      end

      it "should allow three seperate people to be primary secondary and rookie" do
        @shift.primary = @primary
        @shift.secondary = @secondary
        @shift.rookie = @rookie
        expect(@shift).to be_valid
      end

      it "should not let a secondary responder take a primary shift" do
        @shift.primary = @secondary
        expect(@shift).not_to be_valid
      end

      it "should not let a rookie responder take a primary shift" do
        @shift.primary = @rookie
        expect(@shift).not_to be_valid
      end

      it "should not let a responder take two shifts at the same time" do
        shift = create(:shift)
        shift2 = create(:shift)
        shift.primary = @primary
        shift.save
        shift2.primary = @primary
        expect(shift2).not_to be_valid
      end
    end
  end
end
