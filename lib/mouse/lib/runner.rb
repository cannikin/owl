require_relative 'engine'
require_relative 'options'
require 'logger'

module Mouse
  
  class Runner
    
    def initialize(argv)
      @options = Options.new(argv)
      Mouse.options = @options
      
      # initialize logger
      Mouse.logger = Logger.new(@options.log_output)
      Mouse.logger.level = @options.log_level
      
      # get Rails models
      ENV['RAILS_ENV'] = @options.env
      require_relative '../../../config/environment.rb'
      
      @engine = Engine.new()
      
      repeat
    end
    
    def run
      @engine.go
    end
    
    private
    
    # We only check sites at max once every minute
    def repeat
      every @options.interval.seconds do
        run
      end
    end
    
  end
end
