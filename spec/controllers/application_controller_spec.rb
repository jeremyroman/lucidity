require 'spec_helper'

describe ApplicationController do
  it "should get the current user" do
    current_user = controller.send(:current_user)
    current_user.should be_nil
    
    session[:cas_user] = "jlpicard"
    current_user = controller.send(:current_user)
    current_user.should be_a(User)
    current_user.userid.should == "jlpicard"
  end
end