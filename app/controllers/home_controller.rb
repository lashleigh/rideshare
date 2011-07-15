class HomeController < ApplicationController
  def index
    @cities = City.all
  end
end
