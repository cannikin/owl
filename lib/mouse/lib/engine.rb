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
          watch.update_attributes(:last_response_time => time, :status_id => Status::UP)
          response = watch.responses.create(:time => time, :status => http.status, :reason => http.reason)
          if Mouse.options.write_headers
            Mouse.logger.debug("    Saving headers...")
            http.header.get.each do |header|
              response.headers.create(:key => header.first, :value => header.last)
            end
          end
          Mouse.logger.debug("    status: #{http.status}, response time: #{time}ms")
        rescue SocketError => e
          watch.update_attributes(:last_response_time => 0, :status_id => Status::DOWN)
          watch.responses.create(:time => 0, :status => 0, :reason => 'error')
          Mouse.logger.error("  ** No response from #{watch.url}")
        end

      end
    end
      
  end
end