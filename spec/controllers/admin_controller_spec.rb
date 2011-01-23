require 'spec_helper'

describe AdminController do
  describe "switch_user action" do
    before(:each) do
      @admin = Factory.create(:admin)
      @user = Factory.create(:user)
    end
    
    it "should allow administrators to switch user" do
      sign_in :user, @admin
      controller.current_user.stub(:admin?).and_return(true)
      
      post :switch_user, :username => @user.username
      response.should be_redirect
    end
    
    it "should disallow ordinary users from switching users" do
      sign_in :user, @user
      controller.current_user.stub(:admin?).and_return(false)
      
      proc do
        post :switch_user, :username => @user.username
      end.should raise_error(CanCan::AccessDenied)
    end
  end
end
