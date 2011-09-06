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
    @search = Search.new(params)

    respond_to do |format|
      if @search.valid?
        @trips, @center = @search.appropriate_response
        session[:search] = @trips.map{|t| t.id.as_json} if @trips
        format.html { render :action => "show" }
        format.xml  { head :ok }
        format.json { render :json => @trips }
      else
        @trips ||= Trip.sort(:created_at.desc).limit(5).all
        @center ||= [47.6062095, -122.3320708]
        session[:search] = nil
        format.html { render :action => "show" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
        format.json { render :json => @trip.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

end
