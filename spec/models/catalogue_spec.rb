require 'spec_helper'

describe Catalogue do
  it "should have correct relationships" do
    should have_many(:courses)
  end
end
