# CachesMethod
module CachesMethod
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def caches_method(*methods)
      methods.each do |method|
        define_method :"#{method}_with_cache" do
          Rails.cache.fetch("#{cache_key}-#{method}") { send(:"#{method}_without_cache") }
        end

        alias_method_chain method, :cache
      end
    end
  end
  
  def purge_cache(which=:all, options = {})
    options.reverse_merge!(:old => false)
    
    case which
    when Array
      methods = which
    when Symbol, String
      methods = [which]
    else
      raise ArgumentError, "invalid argument supplied to purge_cache"
    end
    
    methods.each do |method|
      key = options[:old] ? cache_key_was : cache_key
      Rails.cache.delete("#{key}-#{method}")
    end
  end
end
