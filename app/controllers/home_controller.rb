class HomeController < ApplicationController
  def index
  end

  def explore
    city = Geocoder.search(params[:city]).first unless params[:city].blank?
    @city = city.address if city
    respond_to do |format|
      if city
        city = city.coordinates
        @trips = Trip.find_all_near(city).all 
        @center = city
        format.html {render :action => "explore" }
        format.xml {head :ok}
      else
        flash[:error] = "There was a problem geocoding"
        format.html {render :action => "explore" }
        format.xml {head :ok}
      end
    end
  end

  def show
    start = Geocoder.search(params[:origin]).first unless params[:origin].blank?
    finish = Geocoder.search(params[:destination]).first unless params[:destination].blank?
    @origin = start.address if start
    @destination = finish.address if finish

    respond_to do |format|
      @trips, @center = show_helper(params, start, finish) 
      format.html { render :action => "show" }
      format.xml  { head :ok }
    end
  end

  def show_helper(params, start, finish)
    if start and finish
      start = start.coordinates
      finish = finish.coordinates
      if params[:exact]
        return Trip.find_all_exact_match(start, finish).all, Geocoder::Calculations::geographic_center([start, finish]) 
      else
        return Trip.find_all_near([start, finish]).all, Geocoder::Calculations::geographic_center([start, finish]) 
      end
    elsif start
      start = start.coordinates
      return Trip.find_all_starting_in(start).all, start
    elsif finish
      finish = finish.coordinates
      return Trip.find_all_finishing_in(finish).all, finish
    else
      flash[:error] = "There was a problem geocoding the location"
    end
  end
 
end
