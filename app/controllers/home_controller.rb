class HomeController < ApplicationController
  def index
  end

  def show
    @origin = params[:origin]
    @destination = params[:destination]
    geo_origins = Geocoder.search(params[:origin])
    geo_destinations = Geocoder.search(params[:destination])
    respond_to do |format|
      unless params[:origin].blank? and params[:destination].blank?
        if params[:origin].blank?
          @match_one = Trip.nearest_with_index(geo_destinations[0])
          format.html { render :action => "show" }
        elsif params[:destination].blank?
          @match_one = Trip.nearest_with_index(geo_origins[0])
          format.html { render :action => "show" }
        else
          if not geo_origins[0].nil? and not geo_destinations[0].nil?
            @matches = Trip.find_match(geo_origins[0], geo_destinations[0])
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
