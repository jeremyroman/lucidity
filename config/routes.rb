ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  map.resources :courses, :collection => { :search => :get }
  map.resources :course_memberships
  map.resources :plans, :member => { :endpoints => :get, :conflicts => :get } do |plans|
    plans.resources :course_memberships, :collection => { :reorder => :post }
  end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => "main"
end
