class CourseMembershipsController < ApplicationController
  def destroy
    @cm = CourseMembership.find(params[:id])
    @cm.destroy
    
    render :nothing => true
  end
end
