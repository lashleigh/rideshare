class HomeController < ApplicationController
  def index
    @avail_places = Place.all.as_json(:only => :address).map {|r| r.to_a.flatten[1]}
  end

  def show
    @origin = params[:origin]
    @destination = params[:destination]
    logger.info(params[:place])
  end
end
