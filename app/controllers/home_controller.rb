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
          @matches = Trip.nearest_with_index(city)
          @trips = @matches["end"].map{|k, v| Trip.find(k)}
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
    @origin = params[:origin]
    @destination = params[:destination]
    start = Geocoder.coordinates(params[:origin])
    finish = Geocoder.coordinates(params[:destination])
    respond_to do |format|
      unless params[:origin].blank? and params[:destination].blank?
        if params[:origin].blank?
          @match_one = Trip.nearest_with_index(finish)
          @trips = @match_one["end"].map{|k, v| Trip.find(k) }
          @center = finish
          format.html { render :action => "show" }
        elsif params[:destination].blank?
          @match_one = Trip.nearest_with_index(start)
          @trips = @match_one["start"].map{|k,v| Trip.find(k)}
          @center = start
          format.html { render :action => "show" }
        else
          if not start.nil? and not finish.nil?
            @matches = Trip.find_match(start, finish)
            @trips = @matches["perfect"].map{|k| Trip.find(k["trip"]) }
            @center = Geocoder::Calculations::geographic_center([start, finish]) 
            format.html { render :action => "show" } #redirect_to(@trip, :notice => 'Trip was successfully updated.') }
            format.xml  { head :ok }
          else 
            flash[:error] = "There was a problem geocoding the provided strings"
            format.html { render :action => "show" }
          end
        end
      else
        flash[:error] = "Please provide a starting and/or an ending point"
        format.html { render :action => "show" }
      end
    end
  end

end
