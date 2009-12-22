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
    
    it "should retrieve a list of plans" do
      new_plan = Plan.create!(:name => "Plan B")
      
      get 'index'
      assigns[:plans].should == Plan.all
      
      new_plan.destroy
    end
  end
end
