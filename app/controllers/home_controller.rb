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
        trips = @search.appropriate_response
        @trips = trips.paginate(:page => params[:page], :per_page => 10)
        format.html { render :action => "show" }
        format.xml  { head :ok }
        format.json { render :json => @trips }
      else
        @search = Search.new
        @trips = Trip.future.sort(:start_date.asc).paginate(:page => params[:page], :per_page => 10)
        format.html { render :action => "show" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
        format.json { render :json => @trip.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

end
