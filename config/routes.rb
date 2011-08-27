Rideshare::Application.routes.draw do
  resources :trips

  match 'home/show' => 'home#show'
  match '/explore' => 'home#explore', :as => :explore
  match 'trips/update_trip_options' => 'trips#update_trip_options'
  match 'trips/:id/map' => 'trips#map', :as => :map

  root :to => "home#index"

end
