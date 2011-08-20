class HomeController < ApplicationController
  def index
  end

  def show
    @origin = params[:origin]
    @destination = params[:destination]
    geo_origins = Geocoder.search(params[:origin])
    geo_destinations = Geocoder.search(params[:destination])
    @trips = {}
    @trips["origin"] = Trip.nearest([geo_origins[0].latitude, geo_origins[0].longitude], {:limit => 3}) 
    @trips["destination"] = Trip.nearest([geo_destinations[0].latitude, geo_destinations[0].longitude]) 
  end
end
