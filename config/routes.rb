Rideshare::Application.routes.draw do
  resources :trips
  resources :users

  match 'home/show' => 'home#show'
  match '/explore' => 'home#explore', :as => :explore
  match 'trips/update_trip_options' => 'trips#update_trip_options'
  match 'trips/:id/map' => 'trips#map', :as => :map

  match "/auth/:provider/callback" => "sessions#create"  
  match "/auth/failure" => "sessions#failure"  
  match "/signout" => "sessions#destroy", :as => :signout

  root :to => "home#index"

end
