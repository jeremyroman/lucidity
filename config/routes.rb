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
    resources :courses, :only => [:index, :new, :create] do
      collection { get :search }
    end
  end
  
  resources :courses, :except => [:index, :new, :create]
  resources :course_memberships, :only => [:show, :create, :update] do
    collection do
      delete :destroy
      get :edit
    end
  end
end
