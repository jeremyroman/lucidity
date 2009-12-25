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
    plan.should have_at_least(1).internal_conflicts
    
    term.update_attribute(:season, "W")
    plan.reload
    plan.should be_internally_consistent
    plan.should have(:no).internal_conflicts
    
    [plan, course].each(&:destroy)
  end
  
  it "should ensure that all course requirements are met" do
    GlobalStub.hook(CourseRequirement, :satisfied?)
    plan = Plan.create!
    term = plan.terms.create!(:name => "1B", :season => "W")
    course = Course.create!(:code => "TEST 137", :name => "Winter Testing", :offered => "W")
    course.course_requirements.create!
    course.course_requirements.create!
    term.courses << course
    term.save!
    
    # shouldn't work if none are satisfied
    GlobalStub[CourseRequirement, :satisfied?] = false
    plan.should_not be_internally_consistent
    plan.should have_at_least(1).internal_conflicts
    
    # should work if all are satisfied
    GlobalStub[CourseRequirement, :satisfied?] = true
    plan.should be_internally_consistent
    plan.should have(:no).internal_conflicts
    
    GlobalStub.unhook(CourseRequirement, :satisfied?)
    [plan, course].each(&:destroy)
  end
end
