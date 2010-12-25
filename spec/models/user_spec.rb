require 'spec_helper'

describe User do
  it "should have the correct relationships" do
    should have_many(:plans)
  end
  
  it "should provide #admin?" do
    User.new.should respond_to(:admin?)
  end
end
