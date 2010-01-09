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
    
    TermSweeper.instance.wrap(controller) do
      plan.terms.each { |term| TermSweeper.instance.expire_cache(term) }
    end
  end
end