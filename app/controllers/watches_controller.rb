require 'lib/spark_pr.rb'

class WatchesController < ApplicationController
  
  NO_RESPONSE_TIME = 100
  
  before_filter :get_graph_cookies, :only => :response_graph
  
  # GET /watches
  # GET /watches.xml
  def index
    @watches = Watch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @watches }
    end
  end

  # GET /watches/1
  # GET /watches/1.xml
  
  def show
    no_cache
    
    @watch = Watch.find(params[:id])
    
    if params[:view] == 'mini'
      render :partial => 'watch', :layout => false
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @watch.to_json(:include => :status) }
        format.json { render :json => @watch.to_json(:include => :status) }
      end
    end
  end

  # GET /watches/new
  # GET /watches/new.xml
  def new
    @watch = Watch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @watch }
    end
  end

  # GET /watches/1/edit
  def edit
    @watch = Watch.find(params[:id])
  end

  # POST /watches
  # POST /watches.xml
  def create
    @watch = Watch.new(params[:watch])

    respond_to do |format|
      if @watch.save
        flash[:notice] = 'Watch was successfully created.'
        format.html { redirect_to(@watch) }
        format.xml  { render :xml => @watch, :status => :created, :location => @watch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @watch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /watches/1
  # PUT /watches/1.xml
  def update
    @watch = Watch.find(params[:id])

    respond_to do |format|
      if @watch.update_attributes(params[:watch])
        flash[:notice] = 'Watch was successfully updated.'
        format.html { redirect_to sites_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @watch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /watches/1
  # DELETE /watches/1.xml
  def destroy
    @watch = Watch.find(params[:id])
    @watch.destroy

    respond_to do |format|
      format.html { redirect_to(watches_url) }
      format.xml  { head :ok }
    end
  end
  
  
  # returns the response time graph for a given watch
  def response_graph
    
    no_cache
    
    logger.debug("  COOKIES: " + cookies[:graphs].to_s)
    
    # if params[:type] comes in then the user wanted to switch types, so save their preference
    if params[:type]
      set_graph_cookies(params[:id], params[:type])
      type = params[:type]
    else
      if this_graph_type = @graph_cookies[params[:id].to_s]
        type = this_graph_type
      else
        type = 'last_24'
      end
    end
    
    if cookies[:graphs].nil?
      set_graph_cookies(params[:id], type)
    end
    
    logger.debug("  TYPE: #{type}")
    key = { :id => params[:id], :type => type }.to_json
  
    # if they didn't pass a type, assume it's the last 24 hours
    points = []
    if type == 'last_24'
      # showing graph for the last 24 hours. Get averages for each hour from the database
      png = data_cache(Digest::MD5.hexdigest(key), {:timeout => 1.hour}) do
        24.times do |num|
          points << (Response.average(:time, :conditions => ["watch_id = ? and time != 0 and created_at < ? and created_at > ?", params[:id], (num).hours.ago.to_s(:db), (num+1).hours.ago.to_s(:db)]) || NO_RESPONSE_TIME)
        end
        Spark.plot(points.reverse, :type => 'smooth', :has_min => true, :has_max => true, :has_last => 'true', :height => 40, :step => 10, :normalize => 'logarithmic' ) 
      end
    elsif type == 'current_24'
      png = data_cache(Digest::MD5.hexdigest(key), {:timeout => 2.minutes}) do
        # showing graph for the last hour. Get averages for every 2 minutes for the last hour from the database
        30.times do |num|
          points << (Response.average(:time, :conditions => ["watch_id = ? and time != 0 and created_at < ? and created_at > ?", params[:id], (num*2).minutes.ago.to_s(:db), (num*2+2).minutes.ago.to_s(:db)]) || NO_RESPONSE_TIME)
        end
        Spark.plot(points.reverse, :type => 'smooth', :has_min => true, :has_max => true, :has_last => 'true', :height => 40, :step => 8, :normalize => 'logarithmic' ) 
      end
    end
    send_data png, :type => 'image/png', :disposition => 'inline'
  end
  
  private
    
    def set_graph_cookies(id,type)
      cookies[:graphs] = (@graph_cookies.merge({ id => type })).to_json
    end
    
    def get_graph_cookies
      @graph_cookies = JSON.parse(cookies[:graphs] || "{}")
    end
  
end
