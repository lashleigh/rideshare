class TripsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :search, :craigslist]
  # GET /trips
  # GET /trips.xml
  def explore
    @center = Geocoder.coordinates(params[:city])
    @trips = Trip.nearest_with_index(@center) 
  end

  def update_summary
    @trip = Trip.find(params[:id])
    @trip.assign({params[:type] => params[:value]})

    respond_to do |format|
      if user_can_modify(@trip) and @trip.save
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
      if user_can_modify(@trip) and t.valid? and @trip.save
        format.json { render :json => @trip.trip_options[params[:type]] }
      else
        format.json { render :json => t.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def search
    @search = Search.new(params)

    respond_to do |format|
      if @search.valid? 
        trips = @search.appropriate_response
        @trips = trips.paginate(:page => params[:page], :per_page => 10)
        format.html { render :action => "search" }
        format.xml  { head :ok }
        format.json { render :json => @trips }
      else
        @search = Search.new
        @trips = Trip.future.sort(:start_date.asc).paginate(:page => params[:page], :per_page => 10)
        format.html { render :action => "search" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
        format.json { render :json => @trip.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def index
    @trips = Trip.future.sort(:start_date.asc).paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trips }
    end
  end

  def favorite
    respond_to do |format|
      if @current_user.togglefavorite(params[:id]) and @current_user.save
        format.json { render :json => params[:id]}
      else
        format.html { render :text => "You are not logged it"}
        format.json { render :json => {:error => "not logged it"}}
      end
    end
  end
  def craigslist
    @trip = Trip.find(params[:id])
    @craigslists =[] #= Craigslist.where(:id => {'$in' => @trip.craigslists}).all #find_all_near_route(@trip)
    @trip.craigslist_ids.each do |c|
      @craigslists.push(Craigslist.find(c))
    end

    respond_to do |format|
      format.html #craigslist.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/1
  # GET /trips/1.xml
  def show
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip
        @owner = user_can_modify(@trip) 
        format.html # show.html.erb
        format.xml  { render :xml => @trip }
      else
        format.html { redirect_to root_url, :status => 301} # show.html.erb
        format.xml  { render :xml => @trip }
      end
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
  end

  # POST /trips
  # POST /trips.xml
  def create
    @trip = Trip.new(params[:trip])
    @trip.user = @current_user

    respond_to do |format|
      if @trip.save
        format.html { redirect_to(@trip, :notice => 'Trip was successfully created.') }
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

    respond_to do |format|
      if user_can_modify(@trip) and @trip.update_attributes(params[:trip])
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

    respond_to do |format|
      if user_can_modify(@trip) and @trip.destroy
        format.html { redirect_to(trips_url) }
        format.xml  { head :ok }
      else
        flash[:error] = "It appears you attempted to delete a suggestion that you did not create. Perhaps you need to log in?"
        format.html { redirect_to root_path }
        format.xml  { head :ok }
      end
    end
  end

  private 
  def user_can_modify(trip)
    trip.user == @current_user || (@current_user and @current_user.admin?)
  end

end
