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
        Mouse.logger.debug("  - Checking watch #{watch.id}: #{watch.url}...")
        begin
          time = Time.now
          http = HTTPClient.get(watch.url)
          time = ((Time.now - time) * 1000).to_i
          if http.status != watch.expected_response       # status code wasn't what was expected
            down(watch, :time => time, :status_reason => "Response code #{http.status} did not match expected (#{watch.expected_response})", :message => 'Response codes do not match expected')
          elsif watch.content_match && !http.body.content.match(watch.content_match)  # content on the page wasn't found
            down(watch, :time => time, :status_reason => "Required content ('#{watch.content_match}') was not found on the page", :message => 'Required content not found on page')
          else                                            # everything looks good, mark as up
            up(watch, :http => http, :time => time)
          end
        rescue SocketError => e                           # URL is invalid
          down(watch, :status_reason => 'URL invalid', :message => 'URL is invalid')
        rescue HTTPClient::ReceiveTimeoutError => e       # Apparently the uncatchable error
          down(watch, :message => 'ReceiveTimeoutError')
        rescue HTTPClient::ConnectTimeoutError => e       # Site isn't responding
          down(watch, :status_reason => 'Timed out waiting for response', :message => 'Site not responding (timeout)')
        end
      end
      
      cleanup   # removes responses older than a day
    end
    
    
    private
    
      # called when a site is considered up
      def up(watch, options={})
        defaults = { :time => 0, :http => nil, :status_reason => 'Site responding normally' }
        options = defaults.merge!(options)
        update_watch(watch, options[:time], Status::UP, options[:status_reason])
        response = add_response(watch, options[:time], options[:http].status, options[:http].reason)
        if Mouse.options.write_headers
          Mouse.logger.debug("    Saving headers...")
          options[:http].header.get.each do |header|
            response.headers.create(:key => header.first, :value => header.last)
          end
        end
      end
      
    
      # called when a site is considered down
      def down(watch, options={})
        defaults = { :time => 0, :http => nil, :status_reason => 'Site is down', :message => 'Error with response' }
        options = defaults.merge!(options)
        update_watch(watch, options[:time], Status::DOWN, options[:status_reason])
        response = add_response(watch, options[:time], options[:http] ? options[:http].status : 0, options[:http] ? options[:http].reason : 'error')
        Mouse.logger.error("  ** #{options[:message]}")
      end
      
      
      # sets a watch to be in the warning status
      def warning(watch)
        watch.update_attributes(:status_id => Status::WARNING)
      end
      
      
      # updates the watch record
      def update_watch(watch, time, status, status_reason)
        watch.status_id = status
        watch.last_status_change_at = Time.zone.now.to_s(:db) if watch.changed?  # only updates the last status change
        watch.last_response_time = time
        watch.status_reason = status_reason
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