# require_relative 'base'
require 'rubygems'
require 'httpclient'

module Mouse
  class Engine

    def initialize
      Mouse.logger.info("Engine started at #{Time.now.to_s}...")
    end
    
    # For each meme, get each lookup and initialize the requisite file in /lib/crawlers (all included in Cralwer::Base below)
    def go
      threads = []
      responses = []
      
      watches = Watch.active
      watches.each do |watch|
        #threads << Thread.new do
          Mouse.logger.debug("  - Checking watch #{watch.id}: #{watch.url}...")
          begin
            time = Time.now
            http = HTTPClient.get(watch.url)
            time = ((Time.now - time) * 1000).to_i
            up(watch, http, time)
          rescue SocketError => e
            # URL is invalid
            down(watch, 'URL is invalid')
          rescue HTTPClient::ReceiveTimeoutError => e
            # Apparently the uncatchable error
            down(watch, 'ReceiveTimeoutError')
          rescue HTTPClient::ConnectTimeoutError => e
            # Site isn't responding
            down(watch, 'Site not responding (timeout)')
          end
        #end
      end
      
      #threads.each { |t| t.join }
      cleanup   # removes responses older than a day
    end
    
    
    private
    
      # called when a site is considered up
      def up(watch, http, time)
        update_watch(watch, time, Status::UP)
        #watch.update_attributes(:last_response_time => time, :status_id => Status::UP)
        response = add_response(watch, time, http.status, http.reason)
        #response = watch.responses.create(:time => time, :status => http.status, :reason => http.reason)
        if Mouse.options.write_headers
          Mouse.logger.debug("    Saving headers...")
          http.header.get.each do |header|
            response.headers.create(:key => header.first, :value => header.last)
          end
        end
        # set this to a warning if the response time was greater than the warning time
        #if watch.warning_time && time > watch.warning_time
        #  warning(watch)
        #end
      end
      
    
      # called when a site is considered down
      def down(watch, message='')
        update_watch(watch, 0, Status::DOWN)
        response = add_response(watch, 0, 0, 'error')
        #watch.responses.create(:time => 0, :status => 0, :reason => 'error')
        Mouse.logger.error("  ** #{message}")
      end
      
      
      # sets a watch to be in the warning status
      def warning(watch)
        watch.update_attributes(:status_id => Status::WARNING)
      end
      
      
      # updates the watch record
      def update_watch(watch, time, status)
        watch.status_id = status
        watch.last_status_change_at = Time.zone.now.to_s(:db) if watch.changed?  # only updates the last status change
        watch.last_response_time = time
        return watch.save
      end
      
      
      # adds a response record
      def add_response(watch, time, status, reason)
        Mouse.logger.debug("    status: #{status}, response time: #{time}ms")
        return watch.responses.create(:time => time, :status => status, :reason => reason)
      end
      
      
      # figures out how much the current ping deviates from the norm
      def deviation
        
      end
      
      
      # removes any responses older than a given time
      def cleanup
        Mouse.logger.debug("Purging records older than #{Mouse.options.oldest} seconds.")
        Watch.destroy_all ['created_at < ?', (Time.now - Mouse.options.oldest).to_s(:db)]
      end
      
  end
end