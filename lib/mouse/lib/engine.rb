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
      watches = Watch.active
      watches.each do |watch|
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
          down(watch, 'ReceiveTimeoutError')
        rescue HTTPClient::ConnectTimeoutError => e
          # Site isn't responding
          down(watch, 'Site not responding (timeout)')
        end

      end
    end
    
    
    private
    
      # called when a site is considered up
      def up(watch, http, time)
        watch.update_attributes(:last_response_time => time, :status_id => Status::UP)
        response = watch.responses.create(:time => time, :status => http.status, :reason => http.reason)
        if Mouse.options.write_headers
          Mouse.logger.debug("    Saving headers...")
          http.header.get.each do |header|
            response.headers.create(:key => header.first, :value => header.last)
          end
        end
        # set this to a warning if the response time was greater than the warning time
        if watch.warning_time && time > watch.warning_time
          warning(watch)
        end
        Mouse.logger.debug("    status: #{http.status}, response time: #{time}ms")
      end
      
    
      # called when a site is considered down
      def down(watch, message='')
        watch.update_attributes(:last_response_time => 0, :status_id => Status::DOWN)
        watch.responses.create(:time => 0, :status => 0, :reason => 'error')
        Mouse.logger.error("  ** #{message}")
      end
      
      
      # sets a watch to be in the warning status
      def warning(watch)
        watch.update_attributes(:status_id => Status::WARNING)
      end
      
  end
end