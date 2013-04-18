Wishlist::Application.routes.draw do
  namespace :admin do
    resources :wishes
  end

  resources :wishes, :only => [:index, :show] do
    post 'prepare_claim', :on => :member
    get 'claim', :on => :member
  end

  match 'owner_protection/:action', {:controller => "owner_protection"}
  root :to => 'owner_protection#index'
end
