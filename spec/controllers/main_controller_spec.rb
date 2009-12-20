require 'spec_helper'

describe MainController do
  describe "GET 'index'" do
    it "should successfully render the correct template" do
      get 'index'
      response.should render_template("main/index.html.erb")
      response.should be_success
    end
    
    it "should be the recipient of the / URL" do
      params_from(:get, "/").should == {:controller => "main", :action => "index"}
    end
  end
end
