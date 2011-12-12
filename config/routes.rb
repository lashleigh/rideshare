Rideshare::Application.routes.draw do
  resources :trips
  resources :users
  match 'craigslists/batch_import' => 'craigslists#batch_import'
  match 'craigslists/batch_save' => 'craigslists#batch_save'
  match 'craigslists/feeds' => 'craigslists#feeds'
  resources :craigslists
  resources :requests
  match 'requests/:id/migrate' => 'requests#migrate', :as => :migrate

  match 'home/show' => 'home#show'

  match 'explore' => 'trips#explore', :as => :explore
  match 'search' => 'trips#search', :as => :search
  match 'trips/update_trip_options' => 'trips#update_trip_options'
  match 'trips/update_summary' => 'trips#update_summary'
  match 'trips/:id/craigslist' => 'trips#craigslist', :as => :trip_craigslist
  match 'trips/:id/show' => 'trips#show', :as => :favorites
  match 'trips/:id/show' => 'trips#show', :as => :flag
  match 'trips/:id/favorite' => 'trips#favorite', :as => :favorite

  match "/auth/:provider/callback" => "sessions#create"  
  match "/auth/failure" => "sessions#failure"  
  match "/signout" => "sessions#destroy", :as => :signout

  root :to => "trips#index"

end
