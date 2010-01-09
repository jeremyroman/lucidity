class CourseRequirementSweeper < ActionController::Caching::Sweeper
  observe CourseRequirement unless Rails.env == "test"
  
  def after_save(cr)
    expire_cache(cr)
  end
  
  def after_destroy(cr)
    expire_cache(cr)
  end
  
  def expire_cache(cr)
    CourseMembershipSweeper.instance.wrap(controller) do
      cr.course.course_memberships.each do |cm|
        CourseMembershipSweeper.instance.expire_cache(cm)
      end
    end
  end
end