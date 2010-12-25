require 'spec_helper'

describe Term do
  it "should have correct relationships" do
    should belong_to(:plan)
    should have_many(:course_memberships)
  end
  
  it "should validate season" do
    should allow_value('fall').for(:season)
    should allow_value('winter').for(:season)
    should allow_value('spring').for(:season)
    should_not allow_value('').for(:season)
    should_not allow_value('banana').for(:season)
  end
  
  it "should validate year" do
    should allow_value('2009').for(:year)
    should allow_value('2012').for(:year)
    should_not allow_value('two thousand and nine').for(:year)
    should_not allow_value('last year').for(:year)
    should_not allow_value('0').for(:year)
    should_not allow_value('3000').for(:year)
    should_not allow_value('').for(:year)
  end
  
  it "should format name" do
    Term.new(:season => 'fall', :year => 2011).name.should == "Fall 2011"
  end
end
