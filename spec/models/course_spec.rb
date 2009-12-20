require 'spec_helper'

describe Course do
  it "should implement #conflict_description" do
    Course.instance_methods.should include("conflict_description")
  end
end
