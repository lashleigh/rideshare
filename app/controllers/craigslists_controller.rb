class CraigslistsController < ApplicationController
  before_filter :require_admin
  def index
    @craigslists = Craigslist.sort(:state, :city).all
  end
  def show
    @craigslist = Craigslist.find(params[:id])
  end
  def update
    @craigslist = Craigslist.find(params[:id])

    respond_to do |format|
      if @craigslist.update_attributes(params[:craigslist])
        format.html { redirect_to(@craigslist, :notice => 'Trip was successfully updated.') }
        format.json { render :json => {}, :status => :ok }
      else
        @craigslist.reload
        format.html { render :action => "show" }
        format.json { render :json => @craigslist.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end
  def batch_save
    @craigslists = ActiveSupport::JSON::decode(params[:craigslists])
    @new =[]
    @craigslists.each do |c|
      unless Craigslist.find_by_city_and_state(c["city"], c["state"])
        city = Craigslist.new(c)
        city.save
        @new.push(city)
      end
    end
    respond_to do |format|
      if @new.length > 0
        format.html { redirect_to(@new[0], :notice => 'Trip was successfully updated.') }
        format.json { render :json => {}, :status => :ok }
      else
        format.html { redirect_to(root_path, :notice => 'No new cities.') }
        format.json { render :json => {}, :status => :ok }
      end
    end
  end
end
