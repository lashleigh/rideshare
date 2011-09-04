class TripsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :craigslist]
  # GET /trips
  # GET /trips.xml
  def update_summary
    @trip = Trip.find(params[:id])
    @trip.assign({params[:type] => params[:value]})
    respond_to do |format|
      if @trip.save
        format.json { render :json => @trip.summary }
      else
        format.json { render :json => t.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def update_trip_options
    @trip = Trip.find(params[:id])
    if params[:type] == "cost"
      params[:value].gsub!("$","")
    end
    t = TripOptions.new(params[:type] => params[:value])
    if t.valid?
      @trip.trip_options.assign({params[:type] => params[:value]})
    end

    respond_to do |format|
      if t.valid?
        @trip.save
        format.json { render :json => @trip.trip_options[params[:type]] }
      else
        format.json { render :json => t.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def index
    @trips = Trip.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.xml
  def map
    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  def favorite
    respond_to do |format|
      if @current_user
        @current_user.toggle_favorite(params[:id])
        format.html #craigslist.html.erb
        format.xml  { render :xml => @trip }
      else
        format.html #craigslist.html.erb
        format.json { render :json => @trip.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end
  def craigslist
    @trip = Trip.find(params[:id])
    @cities = Craigslist.find_all_near_route(@trip)

    respond_to do |format|
      format.html #craigslist.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/1
  # GET /trips/1.xml
  def show
    @trip = Trip.find(params[:id])
    @select_hash = @trip.trip_options.choose_from
    @owner = current_user and @current_user == @trip.user

    if session[:search]
      unless session[:search].index(params[:id]) == 0 || -1
        @prev = Trip.find(session[:search][session[:search].index(params[:id]) - 1]) 
      end
      unless session[:search].index(params[:id]) == session[:search].length-1 ||-1
        @next = Trip.find(session[:search][session[:search].index(params[:id]) + 1]) 
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.xml
  def new
    @trip = Trip.new

    respond_to do |format|
      format.html # { redirect_to edit_trip_path(@trip) } 
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
    @select_hash = @trip.trip_options.choose_from
  end

  # POST /trips
  # POST /trips.xml
  def create
    @trip = Trip.new
    params[:trip].delete_if {|k, v| v.blank?}
    if params[:trip] and params[:trip][:route]
      params[:trip][:route] = ActiveSupport::JSON.decode(params[:trip][:route])
    end
    if params[:trip] and params[:trip][:google_options]
      params[:trip][:google_options] = ActiveSupport::JSON.decode(params[:trip][:google_options])
    end
    @trip.assign(params[:trip])
    @trip.user = current_user

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip } #(@trip, :notice => 'Trip was successfully created.') }
        format.xml  { render :xml => @trip, :status => :created, :location => @trip }
        format.json { render :json => @trip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
        format.json { render :json => @trip.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.xml
  def update
    @trip = Trip.find(params[:id])
    if params[:trip] and params[:trip][:route]
      params[:trip][:route] = ActiveSupport::JSON.decode(params[:trip][:route])
    end
    if params[:trip] and params[:trip][:google_options]
      params[:trip][:google_options] = ActiveSupport::JSON.decode(params[:trip][:google_options])
    end
    @trip.assign(params[:trip])

    respond_to do |format|
      if @trip.save
        @trip.reload
        format.html { redirect_to(@trip, :notice => 'Trip was successfully updated.') }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
        format.json { render :json => @trip.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.xml
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to(trips_url) }
      format.xml  { head :ok }
    end
  end

end
