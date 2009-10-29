require 'lib/spark_pr.rb'

class WatchesController < ApplicationController
  
  NO_RESPONSE_TIME = 100
  
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
    @watch = Watch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @watch }
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
        format.html { redirect_to(@watch) }
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
    points = []
    if params[:type].nil? || params[:type] == 'last_24'
      24.times do |num|
        points << (Response.average(:time, :conditions => ["watch_id = ? and time != 0 and created_at < ? and created_at > ?", params[:id], (num).hours.ago.to_s(:db), (num+1).hours.ago.to_s(:db)]) || NO_RESPONSE_TIME)
      end
      png = Spark.plot(points.reverse, :type => 'smooth', :has_min => true, :has_max => true, :has_last => 'true', :height => 40, :step => 10, :normalize => 'logarithmic' ) 
    elsif params[:type] == 'current_24'
      30.times do |num|
        points << (Response.average(:time, :conditions => ["watch_id = ? and time != 0 and created_at < ? and created_at > ?", params[:id], (num*2).minutes.ago.to_s(:db), (num*2+2).minutes.ago.to_s(:db)]) || NO_RESPONSE_TIME)
      end
      png = Spark.plot(points.reverse, :type => 'smooth', :has_min => true, :has_max => true, :has_last => 'true', :height => 40, :step => 8, :normalize => 'logarithmic' ) 
    end
    logger.debug("Points: #{points.inspect}")
    send_data png, :type => 'image/png', :disposition => 'inline'
  end
  
end
