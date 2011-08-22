Rideshare::Application.routes.draw do
  resources :trips

  match 'home/show' => 'home#show'
  match 'trips/update_location' => 'trips#update_location'
  match 'trips/:id/settings' => 'trips#settings', :as => :settings

  root :to => "home#index"

end
