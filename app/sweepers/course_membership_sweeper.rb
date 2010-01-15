class CourseMembershipSweeper < ActionController::Caching::Sweeper
  observe CourseMembership unless Rails.env == "test"
  
  def after_save(course_membership)
    expire_cache(course_membership)
  end
  
  def after_destroy(course_membership)
    expire_cache(course_membership)
  end
  
  def expire_cache(cm)
    expire_fragment(cm.cache_key_was)
    expire_fragment(cm.term.cache_key)
    cm.purge_cache :conflicts, :old => true
    
    if cm.term_id_changed? or cm.frozen?
      Term.find(cm.term_id_was).touch # expire the old term too
      
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
    
    if cm.course_id_changed? or cm.frozen?
      expire_endpoints(course_membership.term.plan_id)
    end
  end
  
  def expire_endpoints(plan_id)
    expire_action(:controller => "plans", :action => "endpoints", :id => plan_id)
  end
end