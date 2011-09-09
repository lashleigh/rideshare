class SearchController < ApplicationController
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
