require 'spec_helper'

describe CourseRequirement do
  before(:each) do
    @course_group = CourseGroup.create!
    test_101 = @course_group.courses.create!(:code => "TEST 101", :name => "Testing for Engineers", :offered => "FW")
    @course_group.courses.create!(:code => "TEST 111", :name => "Testing", :offered => "FWS")
    @course_group.courses.create!(:code => "TEST 112", :name => "Theoretical Testing", :offered => "F")
    @course_group.save!
    
    @antireq_course_group = CourseGroup.create!
    @antireq_course_group.courses << test_101
    @antireq_course_group.save!
    
    @course = Course.create!(:code => "TEST 230", :name => "Further Testing", :offered => "W")
    @course_requirement = @course.course_requirements.build(:course_group => @course_group, :number => 1, :kind => "prereq")
    @antireq = @course.course_requirements.build(:course_group => @antireq_course_group, :kind => "antireq")
  end
  
  after(:each) do
    @course_group.courses.destroy_all
    @course_group.destroy
    @course.destroy
  end
  
  it "should implement #conflict_description" do
    # does it exist?
    CourseRequirement.instance_methods.should include("conflict_description")
    
    # the following should be true regardless of kind
    %w(prereq coreq antireq).each do |kind|
      @course_requirement.kind = kind
      
      # does it return a String?
      @course_requirement.conflict_description.should be_a(String)
    
      # the conflict description should include all of the required courses' codes
      for course in @course_group.courses
        @course_requirement.conflict_description.should include(course.code)
      end
    
      # the conflict description should also include my course code
      @course_requirement.conflict_description.should include(@course.code)
    end
  end
  
  it "should return an appropriate value for *requisite?" do
    @course_requirement.kind = "prereq"
    @course_requirement.should be_prerequisite
    @course_requirement.should_not be_corequisite
    @course_requirement.should_not be_antirequisite
    
    @course_requirement.kind = "coreq"
    @course_requirement.should be_corequisite
    @course_requirement.should_not be_prerequisite
    @course_requirement.should_not be_antirequisite
    
    @course_requirement.kind = "antireq"
    @course_requirement.should be_antirequisite
    @course_requirement.should_not be_prerequisite
    @course_requirement.should_not be_corequisite
    
    # this is so empty or NULL entries are treated as prerequisites
    # as that's the most likely intended behaviour
    
    @course_requirement.kind = ""
    @course_requirement.should be_prerequisite
    @course_requirement.should_not be_corequisite
    @course_requirement.should_not be_antirequisite
    
    @course_requirement.kind = nil
    @course_requirement.should be_prerequisite
    @course_requirement.should_not be_corequisite
    @course_requirement.should_not be_antirequisite
  end
  
  it "should correctly handle prerequisites" do
    @course_requirement.kind = "prereq"
    
    plan = Plan.create!
    plan.terms.create!(:name => "1A", :season => "F")
    plan.terms.create!(:name => "1B", :season => "W")
    plan.terms.create!(:name => "2A", :season => "F")
    
    @course_requirement.should_not be_satisfied(plan.terms[0], plan)
    @course_requirement.should_not be_satisfied(plan.terms[1], plan)
    @course_requirement.should_not be_satisfied(plan.terms[2], plan)
    
    plan.terms[0].courses << Course.find_by_code("TEST 111")
    @course_requirement.should_not be_satisfied(plan.terms[0], plan)
    @course_requirement.should be_satisfied(plan.terms[1], plan)
    @course_requirement.should be_satisfied(plan.terms[2], plan)
     
    @course_requirement.number = 2
    @course_requirement.should_not be_satisfied(plan.terms[0], plan)
    @course_requirement.should_not be_satisfied(plan.terms[1], plan)
    @course_requirement.should_not be_satisfied(plan.terms[2], plan)
    
    plan.terms[1].courses << Course.find_by_code("TEST 112")
    @course_requirement.should_not be_satisfied(plan.terms[0], plan)
    @course_requirement.should_not be_satisfied(plan.terms[1], plan)
    @course_requirement.should be_satisfied(plan.terms[2], plan)
    
    plan.destroy
  end
  
  it "should correctly handle corequisites" do
    @course_requirement.kind = "coreq"
    
    plan = Plan.create!
    plan.terms.create!(:name => "1A", :season => "F")
    plan.terms.create!(:name => "1B", :season => "W")
    plan.terms.create!(:name => "2A", :season => "F")
    
    @course_requirement.should_not be_satisfied(plan.terms[0], plan)
    @course_requirement.should_not be_satisfied(plan.terms[1], plan)
    @course_requirement.should_not be_satisfied(plan.terms[2], plan)
    
    plan.terms[0].courses << Course.find_by_code("TEST 111")
    @course_requirement.should be_satisfied(plan.terms[0], plan)
    @course_requirement.should be_satisfied(plan.terms[1], plan)
    @course_requirement.should be_satisfied(plan.terms[2], plan)
     
    @course_requirement.number = 2
    @course_requirement.should_not be_satisfied(plan.terms[0], plan)
    @course_requirement.should_not be_satisfied(plan.terms[1], plan)
    @course_requirement.should_not be_satisfied(plan.terms[2], plan)
    
    plan.terms[1].courses << Course.find_by_code("TEST 112")
    @course_requirement.should_not be_satisfied(plan.terms[0], plan)
    @course_requirement.should be_satisfied(plan.terms[1], plan)
    @course_requirement.should be_satisfied(plan.terms[2], plan)
    
    plan.destroy
  end
  
  it "should correctly handle antirequisites" do
    plan = Plan.create!
    plan.terms.create!(:name => "1A", :season => "F")
    plan.terms.create!(:name => "1B", :season => "W")
    
    @antireq.should be_satisfied(plan.terms[0], plan)
    @antireq.should be_satisfied(plan.terms[1], plan)
    
    plan.terms[0].courses << Course.find_by_code("TEST 101")
    @antireq.should_not be_satisfied(plan.terms[1], plan)
    
    plan.destroy
  end
end
