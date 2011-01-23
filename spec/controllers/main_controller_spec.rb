require 'spec_helper'

describe MainController do
  before(:each) do
    @user = Factory.create(:user)
  end
  
  describe 'index action' do
    it 'should accept logged-in users' do
      sign_in :user, @user
      get :index
      response.should be_success
      should render_template('main/index')
    end
    
    it 'should redirect guests' do
      get :index
      response.should be_redirect
    end
  end
end
