class Fixnum
  def seconds
    return self
  end
  alias :second :seconds
  
  def minutes
    return self.seconds * 60
  end
  alias :minute :minutes
  
  def hours
    return self.minutes * 60
  end
  alias :hour :hours
end

# just executes a loop every X seconds/minutes/hours
def every(seconds=10, &block)
  while true
    yield
    sleep(seconds)
  end
end

# simulates Ruby 1.9's require_relative (figures out where to require a file from no matter where it was called)
def require_relative(relative_feature)
  c = caller.first
  fail "Can't parse #{c}" unless c.rindex(/:\d+(:in `.*')?$/)
  file = $`
  if /\A\((.*)\)/ =~ file #eval, etc.
    raise LoadError, "require_relative is called in #{$1}"
  end
  absolute = File.expand_path(relative_feature, File.dirname(file))
  require absolute
end
