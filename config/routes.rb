Rideshare::Application.routes.draw do
  resources :trips
  resources :users

  match 'home/show' => 'home#show'
  match '/explore' => 'home#explore', :as => :explore

  match 'trips/update_trip_options' => 'trips#update_trip_options'
  match 'trips/update_summary' => 'trips#update_summary'
  match 'trips/:id/edit' => 'trips#edit', :as => :map
  match 'trips/:id/craigslist' => 'trips#craigslist', :as => :craigslist
  match 'trips/:id/show' => 'trips#show', :as => :favorites
  match 'trips/:id/show' => 'trips#show', :as => :flag
  match 'trips/:id/favorite' => 'trips#favorite', :as => :favorite

  match "/auth/:provider/callback" => "sessions#create"  
  match "/auth/failure" => "sessions#failure"  
  match "/signout" => "sessions#destroy", :as => :signout

  root :to => "home#index"

end
