class CourseMembershipSweeper < ActionController::Caching::Sweeper
  observe CourseMembership
  
  def after_create(course_membership)
    expire_cache(course_membership)
    expire_endpoints(course_membership.term.plan_id)
  end
  
  def after_update(course_membership)
    expire_cache(course_membership)
    expire_endpoints(course_membership.term.plan_id) if course_membership.course_id_changed?
  end
  
  def after_destroy(course_membership)
    expire_cache(course_membership)
    expire_endpoints(course_membership.term.plan_id)
  end
  
  def expire_cache(cm)
    expire_fragment(cm.cache_key)
    expire_fragment("terms/#{cm.term_id}") # no need to fetch the model to get its cache key
    
    if cm.term_id_changed?
      expire_fragment("terms/#{cm.term_id_was}") # expire the old term too
    
      # find memberships that may care about this course
      # and expire them too
      terms = Term.find(:all, :conditions => {:plan_id => cm.term.plan_id},
        :include => {:course_memberships => {:course => {:course_requirements => {:course_group => :courses}}}})
        
      for term in terms
        for other_cm in term.course_memberships
          if other_cm.course.course_requirements.any? { |cr| cr.course_group.course_ids.include?(cm.course_id) }
            expire_cache(other_cm)
          end
        end
      end
    end
  end
  
  def expire_endpoints(plan_id)
    expire_action(:controller => "plans", :action => "endpoints", :id => plan_id)
  end
end