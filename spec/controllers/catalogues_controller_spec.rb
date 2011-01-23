require 'spec_helper'

describe CataloguesController do
  before(:each) do
    @admin = Factory.create(:admin)
    @user = Factory.create(:user)
    @catalogue = Factory.create(:catalogue)
  end

  describe "index action" do
    it "should fetch all catalogues" do
      sign_in :user, @user
      get :index
      assigns[:catalogues].should == Catalogue.all
      response.should be_success
    end
  end

  describe "show action" do
    it "should fetch the requested catalogue" do
      sign_in :user, @user
      get :show, :id => @catalogue
      assigns[:catalogue].should == @catalogue
      response.should redirect_to([@catalogue, :courses])
    end
  end

  describe "new action" do
    it "should allow admins to instantiate a catalogue" do
      sign_in :user, @admin
      controller.current_user.stub!(:admin?).and_return(true)
      get :new
      assigns[:catalogue].should be_new_record
      assigns[:catalogue].should be_a(Catalogue)
      response.should be_success
    end
  end

  describe "create action" do
    it "should allow admins to create a catalogue" do
      sign_in :user, @admin
      controller.current_user.stub!(:admin?).and_return(true)

      expect do
        post :create, :catalogue => Factory.attributes_for(:catalogue)
      end.to change(Catalogue, :count).by(1)

      response.should redirect_to(assigns[:catalogue])
    end

    it "should stop non-admins from creating a catalogue" do
      sign_in :user, @user
      controller.current_user.stub!(:admin?).and_return(false)

      proc do
        post :create, :catalogue => Factory.attributes_for(:catalogue)
      end.should raise_error(CanCan::AccessDenied)
    end
  end

  describe "edit action" do
    it "should allow admins to begin editing a catalogue" do
      sign_in :user, @admin
      controller.current_user.stub!(:admin?).and_return(true)
      get :edit, :id => @catalogue
      assigns[:catalogue].should == @catalogue
      response.should be_success
    end
  end

  describe "update action" do
    it "should allow admins to update a catalogue" do
      sign_in :user, @admin
      controller.current_user.stub!(:admin?).and_return(true)

      put :update, :id => @catalogue, :catalogue => {:name => "Updated Catalogue"}
      response.should redirect_to(assigns[:catalogue])

      @catalogue.reload
      @catalogue.name.should == "Updated Catalogue"
    end

    it "should stop non-admins from updating a catalogue" do
      sign_in :user, @user
      controller.current_user.stub!(:admin?).and_return(false)

      proc do
        put :update, :id => @catalogue, :catalogue => {:name => "Updated Catalogue"}
      end.should raise_error(CanCan::AccessDenied)
    end
  end

  describe "destroy action" do
    it "should allow admins to destroy a catalogue" do
      sign_in :user, @admin
      controller.current_user.stub!(:admin?).and_return(true)

      expect do
        delete :destroy, :id => @catalogue
      end.to change(Catalogue, :count).by(-1)

      response.should be_redirect
    end

    it "should stop non-admins from destroying a catalogue" do
      sign_in :user, @user
      controller.current_user.stub!(:admin?).and_return(false)

      proc do
        delete :destroy, :id => @catalogue
      end.should raise_error(CanCan::AccessDenied)
    end
  end
end
