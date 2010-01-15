class TermSweeper < ActionController::Caching::Sweeper
  observe Term unless Rails.env == "test"
  
  def after_save(term)
    expire_cache(term)
  end
  
  def after_destroy(term)
    expire_cache(term)
  end
  
  def expire_cache(term)
    expire_fragment(term.cache_key_was)
    expire_fragment(term.cache_key)
  end
end