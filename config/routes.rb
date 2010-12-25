Lucidity::Application.routes.draw do
  root :to => "main#index"
  match 'logout' => 'main#logout'
  
  resources :plans do
    member do
      get :duplicate
      post :duplicate
    end
  end
  
  resources :catalogues do
    resources :courses, :only => [:index, :new, :create]
  end
  
  resources :courses, :except => [:index, :new, :create]
  resources :course_memberships, :only => [:create, :destroy]
end
