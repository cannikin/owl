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
    if params[:site]
      @sites = Site.find(params[:site], :include => { :watches => :status }).to_a
    else
      @sites = Site.all :include => { :watches => :status }
    end
  end

end
