require 'spec_helper'

describe Plan do
  it "should have correct relationships" do
    should belong_to(:user)
    should have_many(:terms)
  end
  
  it "should validate name" do
    should allow_value("My Plan").for(:name)
    should_not allow_value("").for(:name)
  end
  
  it "should spawn terms" do
    plan = Plan.new(:name => "My Plan", :term_spawn => {:num_terms => 11, :first_year => 2009})
    plan.should have(11).terms
    
    plan.terms[0].season.should == 'fall'
    plan.terms[0].year.should == 2009
    
    plan.terms[1].season.should == 'winter'
    plan.terms[1].year.should == 2010
  end
  
  it "should duplicate correctly" do
    plan = Plan.create(:name => "My Plan", :term_spawn => {:num_terms => 11, :first_year => 2009})
    plan2 = plan.duplicate
    plan2.should have(11).terms
    plan2.id.should_not == plan.id
  end
end
