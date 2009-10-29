class DashboardController < ApplicationController
  
  def index
    @page_title = 'Dashboard'
    @sites = Site.all :include => { :watches => :status }
  end

end
