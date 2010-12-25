require 'spec_helper'

describe ApplicationHelper do
  it "should have a working title helper" do
    helper.title.should be_nil
    helper.title("My Title")
    helper.title.should == "My Title"
    helper.title("Another Title")
    helper.title.should == "Another Title"
  end
end
