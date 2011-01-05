Lucidity::Application.routes.draw do
  root :to => 'main#index'
  
  devise_for :users do
    get 'logout' => 'main#logout'
    get 'login' => 'main#index'
  end
  
  match 'admin/switch_user' => 'admin#switch_user', :as => 'switch_user'
  
  resources :plans do
    member do
      get :duplicate
      post :duplicate
    end
  end
  
  resources :catalogues, :shallow => true do
    resources :courses do
      collection { get :search }
    end
  end
  
  resources :terms, :only => [] do
    resources :course_memberships, :except => [:index, :new]
  end
end
