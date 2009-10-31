class DashboardController < ApplicationController
  
  def index
    extended
    render :extended
  end
  
  def extended
    @page_title = 'Dashboard'
    @sites = Site.all :include => { :watches => :status }
  end
  
  def compact
    @page_title = 'Dashboard'
    @sites = Site.all :include => { :watches => :status }
  end

end
