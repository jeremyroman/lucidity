class PlanSweeper < ActionController::Caching::Sweeper
  observe Plan unless Rails.env == "test"
  
  def after_update(plan)
    expire_cache(plan)
  end
  
  def after_destroy(plan)
    expire_cache(plan)
  end
  
  def expire_cache(plan)
    expire_action(:controller => "main", :action => "index")
  end
end