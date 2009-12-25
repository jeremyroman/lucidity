require 'spec_helper'

describe Endpoint do
  before(:each) do
    @endpoint = Endpoint.create!(:name => "BTest")
  end
  
  after(:each) do
    @endpoint.destroy
  end
  
  it "should ensure that all endpoint requirements are met" do
    GlobalStub.hook(EndpointRequirement, :satisfied?)
    plan = Plan.new
    @endpoint.endpoint_requirements.create!
    @endpoint.endpoint_requirements.create!
    
    # shouldn't work if none are satisfied
    GlobalStub[EndpointRequirement, :satisfied?] = false
    @endpoint.should_not be_satisfied(plan)
    @endpoint.should have_at_least(1).conflicts_with_plan(plan)
    
    # should work if all are satisfied
    GlobalStub[EndpointRequirement, :satisfied?] = true
    @endpoint.should be_satisfied(plan)
    @endpoint.should have(:no).conflicts_with_plan(plan)
    
    GlobalStub.unhook(EndpointRequirement, :satisfied?)
    @endpoint.endpoint_requirements.destroy_all
  end
end
