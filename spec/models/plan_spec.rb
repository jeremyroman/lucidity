require 'spec_helper'

describe Plan do
  it "should not allow courses to be taken in the wrong season" do
    plan = Plan.create!
    term = plan.terms.create!(:name => "1A")
    course = Course.create!(:code => "TEST 137", :name => "Winter Testing", :offered => "W")
    term.courses << course
    
    term.update_attribute(:season, "F")
    plan.reload
    plan.should_not be_internally_consistent
    
    term.update_attribute(:season, "W")
    plan.reload
    plan.should be_internally_consistent
    
    [plan, term, course].each(&:destroy)
  end
end