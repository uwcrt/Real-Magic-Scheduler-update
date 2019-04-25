require 'spec_helper'

describe ShiftType do

  before(:each) do
    @attr = {
      :name => "Regular",
      :primary_requirement => 10,
      :secondary_requirement => 12
    }
  end

  it "should create a new ShiftType given valid attributes" do
    ShiftType.create!(@attr)
  end

  it "should require a name" do
    @shift = ShiftType.create(@attr.merge(:name => ""))
    expect(@shift).not_to be_valid
  end

  it "should require a primary_requirement" do
    @shift = ShiftType.create(@attr.merge(:primary_requirement => ""))
    expect(@shift).not_to be_valid
  end

  it "should require a secondary_requirement" do
    @shift = ShiftType.create(@attr.merge(:secondary_requirement => ""))
    expect(@shift).not_to be_valid
  end

  it "should require a numeric primary_requirement" do
    @shift = ShiftType.create(@attr.merge(:primary_requirement => "foobar"))
    expect(@shift).not_to be_valid
  end

  it "should require a numeric secondary_requirement" do
    @shift = ShiftType.create(@attr.merge(:secondary_requirement => "foobar"))
    expect(@shift).not_to be_valid
  end
end
