Wishlist::Application.routes.draw do
  namespace :admin do
    resources :wishes
  end

  resources :wishes, :only => [:index, :show] do
    get 'take', :on => :member
  end

  match 'owner_protection/:action', {:controller => "owner_protection"}
  root :to => 'owner_protection#index'
end
