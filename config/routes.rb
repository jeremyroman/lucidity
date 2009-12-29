ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  map.resources :courses, :collection => { :search => :get }
  map.resources :plans, :member => { :endpoints => :get, :conflicts => :get, :reorder => :post }
  map.resources :course_memberships
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => "main"
end
