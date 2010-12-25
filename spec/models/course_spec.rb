require 'spec_helper'

describe Course do
  it "should have correct relationships" do
    should belong_to(:catalogue)
    should have_many(:course_memberships)
  end
  
  it "should validate course code" do
    should allow_value("CHEM 123").for(:code)
    should allow_value("EARTH 122L").for(:code)
    should_not allow_value("x").for(:code)
    should_not allow_value("").for(:code)
  end
  
  it "should validate terms offered" do
    should allow_value("FWS").for(:offered)
    should allow_value("FS").for(:offered)
    should allow_value("W").for(:offered)
    should_not allow_value("FWX").for(:offered)
  end
  
  it "should generate a correct to_param" do
    course = Course.new(:code => "CHEM 123")
    course.id = 5
    course.to_param.should == "5-CHEM-123"
  end
end
