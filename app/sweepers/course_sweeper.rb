class CourseSweeper < ActionController::Caching::Sweeper
  observe Course unless Rails.env == "test"
  
  def after_save(course)
    expire_cache(course)
  end
  
  def after_destroy(course)
    expire_cache(course)
  end
  
  def expire_cache(course)
  end
end