class HomeController < ApplicationController
  def index
    @avail_places = Place.all.as_json(:only => :address).map {|r| r.to_a.flatten[1]}
  end

  def show
    @origin = Place.find_by_address(params[:origin])
    @destination = Place.find_by_address(params[:destination])

    @cities_hash = Hash[Place.all.map { |r| [r.id, r] }]
    @avail_places = Place.all.as_json(:only => :address).map {|r| r.to_a.flatten[1]}

    @origin_trips = []
    @destination_trips = []
    @origin.active_rides.each {|t| @origin_trips.push(Trip.find_by_id(t)) }
    @destination.active_rides.each {|t| @destination_trips.push(Trip.find_by_id(t)) }
    @perfect_matches = @origin_trips & @destination_trips
    @origin_trips = @origin_trips - @perfect_matches
    @destination_trips = @destination_trips - @perfect_matches
    logger.info(@perfect_matches)
  end
end
