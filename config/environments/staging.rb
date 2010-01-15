config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

config.log_level = :debug

config.cache_store = :file_store, "#{RAILS_ROOT}/tmp/cache/objects"
ActionController::Base.cache_store = :file_store, "#{RAILS_ROOT}/tmp/cache"