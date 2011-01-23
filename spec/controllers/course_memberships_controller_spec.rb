require 'spec_helper'

describe CourseMembershipsController do
  before(:each) do
    @term = Factory.create(:term)
    @course = Factory.create(:course)
    @user1 = @term.plan.user
    @user2 = Factory.create(:user)
  end
  
  describe 'create action' do
    it 'should allow creation of course memberships' do
      sign_in :user, @user1
      
      expect do
        post :create,
          :term_id => @term,
          :course_membership => {:course_id => @course},
          :format => :json
      end.to change(@term.course_memberships, :count).by(1)
      
      assigns[:course_membership].should be_a(CourseMembership)
      assigns[:course_membership].course_id.should == @course.id
      assigns[:course_membership].term_id.should == @term.id
      
      response.should be_success
      should respond_with_content_type(:json)
    end
    
    it 'should restrict creation of course memberships to plans the user owns' do
      sign_in :user, @user2
      
      proc do
        post :create,
          :term_id => @term,
          :course_membership => {:course_id => @course},
          :format => :json
      end.should raise_error(CanCan::AccessDenied)
    end
  end
  
  describe 'destroy action' do
    it 'should allow destruction of course memberships' do
      sign_in :user, @user1
      @cm = @term.course_memberships.create(:course_id => @course)
      
      expect do
        delete :destroy,
          :term_id => @term,
          :id => @cm,
          :format => :json
      end.to change(@term.course_memberships, :count).by(-1)
      
      response.should be_success
      should respond_with_content_type(:json)
    end
    
    it 'should not allow destroying course memberships of others' do
      sign_in :user, @user2
      @cm = @term.course_memberships.create(:course_id => @course)
      
      proc do
        delete :destroy,
          :term_id => @term,
          :id => @cm,
          :format => :json
      end.should raise_error(CanCan::AccessDenied)
    end
  end
  
  describe 'edit action' do
    it 'should show the edit form' do
      sign_in :user, @user1
      @cm = @term.course_memberships.create(:course_id => @course)
      
      get :edit, :term_id => @term, :id => @cm
      
      assigns[:course_membership].should == @cm
      should render_template('edit')
    end
  end
  
  describe 'update action' do
    it 'should allow users to update their own course memberships' do
      sign_in :user, @user1
      @cm = @term.course_memberships.create(:course_id => @course, :override => false)
      
      put :update,
        :term_id => @term,
        :id => @cm,
        :course_membership => {:override => true},
        :format => :json
      
      should respond_with_content_type(:json)
      @cm.reload
      @cm.override.should == true
    end
  end
end
