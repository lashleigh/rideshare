Rideshare::Application.routes.draw do
  resources :trips
  match 'trips/update_location' => 'trips#update_location'

  root :to => "home#index"

end
