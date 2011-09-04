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
    @search = params
    @search["origin"] = start.address if start
    @search["destination"] = finish.address if finish
    @search["origin_coords"] = ActiveSupport::JSON.decode(params[:origin_coordinates]) || (start.coordinates if start)
    @search["destination_coords"] = ActiveSupport::JSON.decode(params[:destination_coordinates]) || (finish.coordinates if finish)

    respond_to do |format|
      @trips, @center = show_helper(params, start, finish) 
      session[:search] = @trips.map{|t| t.id.as_json} if @trips
      logger.info(session[:search])
      @trips ||= Trip.sort(:created_at.desc).limit(5).all
      @center ||= [47.6062095, -122.3320708]
      format.html { render :action => "show" }
      format.xml  { head :ok }
    end
  end

  def show_helper(params, start, finish)
    if start and finish
      start = start.coordinates
      finish = finish.coordinates
      return Trip.find_by_start_finish(start, finish, params).all, Geocoder::Calculations::geographic_center([start, finish]) 
    elsif start
      start = start.coordinates
      params[:origin_radius] ||= 50
      params[:radius] = params[:origin_radius].to_f
      return Trip.find_all_starting_in(start, params).all, start
    elsif finish
      finish = finish.coordinates
      params[:destination_radius] ||= 50
      params[:radius] = params[:destination_radius].to_f
      return Trip.find_all_finishing_in(finish, params).all, finish
    else
      flash[:error] = "There was a problem geocoding the location"
      return nil
    end
  end
 
end
