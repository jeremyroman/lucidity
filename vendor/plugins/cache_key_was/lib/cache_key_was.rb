# CacheKeyWas
module CacheKeyWas
  def cache_key_was
    case
    when new_record?
      "#{self.class.model_name.cache_key}/new"
    when timestamp = self.updated_at_was
      "#{self.class.model_name.cache_key}/#{id_was}-#{timestamp.to_s(:number)}"
    else
      "#{self.class.model_name.cache_key}/#{id_was}"
    end
  end
end