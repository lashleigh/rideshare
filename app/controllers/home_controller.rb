class HomeController < ApplicationController
  def index
  end

  def explore
    @city = params[:city]
    city = Geocoder.coordinates(params[:city])
    respond_to do |format|
      unless params[:city].blank?
        if city.nil?
          flash[:error] = "There was a problem geocoding"
          format.html {render :action => "explore" }
          format.xml {head :ok}
        else
          @trips = Trip.find_all_near(city).all 
          @center = city
          format.html {render :action => "explore" }
          format.xml {head :ok}
        end
      else
        flash[:error] = "Please provide a city to explore"
        format.html {render :action => "explore" }
      end
    end
  end

  def show
    @origin = params[:origin] unless params[:origin].blank? 
    @destination = params[:destination] unless params[:destination].blank? 
    start = Geocoder.coordinates(params[:origin])
    finish = Geocoder.coordinates(params[:destination])
    respond_to do |format|
      @trips, @center = show_helper(params, start, finish) 
      format.html { render :action => "show" }
      format.xml  { head :ok }
    end
  end

  def show_helper(params, start, finish)
    if start and finish
      return Trip.find_all_exact_match(start, finish).all, Geocoder::Calculations::geographic_center([start, finish]) 
    elsif start
      return Trip.find_all_starting_in(start).all, start
    elsif finish
      return Trip.find_all_finishing_in(finish).all, finish
    else
      flash[:error] = "There was a problem geocoding the location"
    end
  end
 
end
