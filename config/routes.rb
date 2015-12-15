Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  match 'users/:id' => 'users#destroy', via: :delete, as: :user_delete
  match 'users/:id/edit' => 'users#edit', via: :get, as: :user_edit
  match 'users/:id' => 'users#update', via: :patch, as: :user_update
  root 'listings#index'


  resources :users, only:[:show] do
    resources :reviews, only: [:new, :create, :destroy]
    resources :favorite_users, only: [:create, :destroy]
  end
  get "/stripe-signup" => 'users#stripe_signup'

  resources :messages, only: [:index]

  resources :bookings, only: [] do
    resources :messages, only: [:new]
  end
  get '/listings/:id/total', to: "listings#total"
  get '/listings/:id/bookings/confirmation', to: "bookings#confirmation"
  
  resources :listings do
    resources :bookings
    resources :reviews, only: [:new, :create, :destroy]
    resources :favorite_listings, only: [:create, :destroy]
    resources :parking_slots, only: [:new,:index,:create]

  end
  get '/listings/:id/availability', to: "listings#availability"

  get "listings/:id/bookings/complete" => 'bookings#show'

  resources :parking_slots, only:[:show,:edit,:update] do
    resources :time_slots
  end

  get '/parking_slots/:id/calendar', to: 'parking_slots#calendar'

  # namespace :api, defaults: {format: :json} do
  #   resources :parking_slots,only:[] do
  #     resources :parking_slots_time_slots, only:[:index]
  #   end
  # end
  
  get "/search" => 'listings#search'
  post '/search' => 'listings#search_map'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
