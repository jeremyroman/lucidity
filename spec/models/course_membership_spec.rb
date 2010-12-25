require 'spec_helper'

describe CourseMembership do
  it "should have correct relationships" do
    should belong_to(:course)
    should belong_to(:term)
  end
end
