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
    @shift.should_not be_valid
  end
  
  it "should require a primary_requirement" do
    @shift = ShiftType.create(@attr.merge(:primary_requirement => ""))
    @shift.should_not be_valid
  end
  
  it "should require a secondary_requirement" do
    @shift = ShiftType.create(@attr.merge(:secondary_requirement => ""))
    @shift.should_not be_valid
  end
  
  it "should require a numeric primary_requirement" do
    @shift = ShiftType.create(@attr.merge(:primary_requirement => "foobar"))
    @shift.should_not be_valid
  end
  
  it "should require a numeric secondary_requirement" do
    @shift = ShiftType.create(@attr.merge(:secondary_requirement => "foobar"))
    @shift.should_not be_valid
  end
end
