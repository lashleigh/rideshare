Rideshare::Application.routes.draw do
  resources :trips

  match 'home/show' => 'home#show'
  match '/explore' => 'home#explore', :as => :explore
  match 'trips/update_location' => 'trips#update_location'
  match 'trips/jeditable' => 'trips#jeditable'
  match 'trips/:id/map' => 'trips#map', :as => :map

  root :to => "home#index"

end
