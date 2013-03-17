Wishlist::Application.routes.draw do
  resources :wishes

  root :to => 'wishes#index'
end
