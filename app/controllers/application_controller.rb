# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  
    # Cache anything! Pass a block of what to cache if a lookup for passed +key+ isn't found. Usage:
    #   output = data_cache('foo', :timeout => 1.hour) { 'hello, world' }
    # Looks for something in memcache with the +key+ 'foo' and returns it if found. If not found, then store 'hello, world' 
    # with the +key+ 'foo' and return to the caller. ie. +output+ will always equal the value of the block.
    def data_cache(key, options={}, &block)
      defaults = { :timeout => 1.hour, :error_message => 'ERROR: Error when executing data_cache block' }
      key = key.to_s
      options = defaults.merge(options)
      begin
        unless output = CACHE.get(key)
          output = yield
          CACHE.set(key, output, options[:timeout])
          logger.debug("Cache MISS and STORE: #{key}")
        else
          logger.debug("Cache HIT: #{key}")
        end
      rescue MemCache::MemCacheError => e
        output = yield
        logger.debug("Cache ERROR: Cache not available or not responding")
        # notify_hoptoad(e)
      rescue => e
        logger.debug("\n#{options[:error_message]}:\n  #{e.message}\n#{e.backtrace}")
      end
      return output
    end
  
  
    # Tell the browser not to cache a page. Just include a call to 'no_cache' in the action you don't want cached (or add as a before_filter)
    def no_cache
      response.headers["Last-Modified"] = Time.now.httpdate
      response.headers["Expires"] = Time.now.httpdate
      response.headers["Pragma"] = "no-cache" # HTTP 1.0
      response.headers["Cache-Control"] = 'no-store, no-cache, must-revalidate, max-age=0, pre-check=0, post-check=0' # HTTP 1.1 'pre-check=0, post-check=0' (IE specific)
    end
  
end
