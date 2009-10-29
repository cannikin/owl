require 'memcache'

begin
  if RAILS_ENV == 'production'
    memcache_host = '10.251.215.212'
  else
    memcache_host = '127.0.0.1'
  end
  CACHE = MemCache.new(memcache_host)
rescue MemCache::MemCacheError => e
  RAILS_DEFAULT_LOGGER.error('Initializing CACHE failed: memcached server not running or not responding')
  # HoptoadNotifier.notify(e)
end
