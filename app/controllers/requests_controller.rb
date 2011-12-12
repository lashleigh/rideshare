class RequestsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  def index
    @requests = Request.all #.sort(:start_date.asc).paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @requests }
    end
  end

  def migrate
    @request = Request.find(params[:id])
    @trip = @request.migrate

    respond_to do |format|
      format.html { redirect_to edit_trip_path(@trip) }
      format.xml  { render :xml => @request }
    end
  end

  # GET /g/1.xml
  def show
    @request = Request.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @request }
    end
  end

  # GET /g/new
  # GET /g/new.xml
  def new
    @request = Request.new

    respond_to do |format|
      format.html # { redirect_to edit_request_path(@request) } 
      format.xml  { render :xml => @request }
    end
  end

  def edit
    @request = Request.find(params[:id])
  end
 
  def update
    @request = Request.find(params[:id])

    respond_to do |format|
      if user_can_modify(@request) and @request.update_attributes(params[:request])
        format.html { redirect_to(@request, :notice => 'Request was successfully updated.') }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @request.errors, :status => :unprocessable_entity }
        format.json { render :json => @request.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @request = Request.find(params[:id])

    respond_to do |format|
      if user_can_modify(@request) and @request.destroy
        format.html { redirect_to(requests_url) }
        format.xml  { head :ok }
      else
        flash[:error] = "It appears you attempted to delete a request that you did not create. Perhaps you need to log in?"
        format.html { redirect_to root_path }
        format.xml  { head :ok }
      end
    end
  end


end
