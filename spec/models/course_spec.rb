require 'spec_helper'

describe Course do
  before(:all) do
    @course = Course.new(:code => "TEST 101", :name => "Testing", :offered => "FW")
  end
  
  it "should implement #conflict_description" do
    # does it exist?
    Course.instance_methods.should include("conflict_description")
    
    # does it return a String?
    @course.conflict_description.should be_a(String)
    
    # to be useful, it should include the code of the problematic course
    @course.conflict_description.should include(@course.code)
  end
end
