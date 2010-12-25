require 'spec_helper'

describe MainController do

  describe "GET 'index'" do
    it "should be successful" do
      session[:cas_user] = 'jlpicard'
      get 'index'
      response.should be_success
    end
  end
  
  describe "GET 'logout'" do
    it "should redirect" do
      get 'logout'
      response.should be_redirect
    end
  end
end
