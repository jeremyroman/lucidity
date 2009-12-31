require 'spec_helper'

describe CourseMembership do
  it "should respect the 'override' field" do
    plan = Plan.create!
    term = plan.terms.create!(:name => "1A", :season => "F")
    course = Course.create!(:code => "TEST 137", :name => "Winter Testing", :offered => "W")
    term.courses << course
    
    cm = term.course_memberships[0]
    cm.should_not be_satisfied
    cm.should have_at_least(1).conflicts
    
    cm.update_attribute(:override, true)
    cm.should be_satisfied
    cm.should have(:no).conflicts
    
    [plan, course].each(&:destroy)
  end
end
