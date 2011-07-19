class HomeController < ApplicationController
  def index
    @avail_places = Place.all.as_json(:only => :address).map {|r| r.to_a.flatten[1]}
  end

  def show
    @cities_hash = Hash[Place.all.map { |r| [r.id, r] }]
    @avail_places = Place.all.as_json(:only => :address).map {|r| r.to_a.flatten[1]}

    origin = Place.find_by_address(params[:origin]) 
    destination = Place.find_by_address(params[:destination]) 
    @result_hash = Hash.new
    @result_hash["origin"] = {"loc" => origin }
    @result_hash["destination"] = {"loc" => destination}
    @result_hash["origin"]["trips"] = []

    origin_trips = []
    destination_trips = []
    origin.active_rides.each {|t| origin_trips.push(Trip.find_by_id(t)) }
    destination.active_rides.each {|t| destination_trips.push(Trip.find_by_id(t)) }

    @result_hash["perfect_matches"] = origin_trips & destination_trips
    @result_hash["origin_trips"] = origin_trips - @result_hash["perfect_matches"]
    @result_hash["destination_trips"] = destination_trips - @result_hash["perfect_matches"]
  end
end
