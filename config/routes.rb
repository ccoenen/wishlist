Wishlist::Application.routes.draw do
  namespace :admin do
    resources :wishes do
     post 'sort', :on => :collection
    end
  end

  resources :wishes, :only => [:index, :show] do
    post 'prepare_claim', :on => :member
    get 'claim', :on => :member

    match 'owner_protection', :on => :collection, :action => :owner_protection
    match 'visitor', :on => :collection, :action => :visitor
    match 'owner', :on => :collection, :action => :owner
  end

  root :to => 'wishes#owner_protection'
end
