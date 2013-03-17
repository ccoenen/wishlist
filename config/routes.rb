Wishlist::Application.routes.draw do
  resources :wishes, :only => [:index, :show] do
    get 'take', :on => :member
  end

  root :to => 'wishes#index'
end
