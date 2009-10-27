class DashboardController < ApplicationController
  
  def index
    @sites = Site.all
  end

end
