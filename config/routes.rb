Wishlist::Application.routes.draw do
  namespace :admin do
    resources :wishes
  end

  resources :wishes, :only => [:index, :show] do
    get 'take', :on => :member
  end

  root :to => 'wishes#index'
end
