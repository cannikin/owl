require 'optparse'
require 'logger'

module Mouse
  class Options
    
    attr_reader :env, :log_level, :log_output, :interval, :write_headers
    
    def initialize(argv)
      @env = 'development'
      @log_level = Logger::DEBUG
      @log_output = STDOUT
      @interval = 60
      @write_headers = false
      parse(argv)
    end
    
    private
    def parse(argv)
      OptionParser.new do |opts|
        opts.on("-e [env]", "--environment [evn]", ['development', 'test', 'production'], "Rails environment development|test|production (default = development)") do |env|
          @env = env unless env.nil?
          case env
          when 'production'
            @log_level = Logger::INFO
            @log_output = File.dirname(__FILE__) + '/../../../log/mouse.log'
          end
        end
        
        opts.on("-d", "--debug", "Logs in verbose mode (this is default when running in development environment)") do
          @log_level = Logger::DEBUG
        end
        
        opts.on("-i [seconds]", "--interval [seconds]", "The interval to crawl at, in seconds (default is 10 seconds)") do |seconds|
          @interval = seconds.to_i unless seconds.nil?
        end
        
        opts.on("-w", "--write-headers", "Write response headers to database") do
          @write_headers = true
        end

        opts.on("-v", "--version", "Mouse version") do
          puts "Mouse " + Mouse::VERSION
          exit 0
        end

        opts.on("-h", "--help", "This help text") do
          puts opts
          exit 0
        end
        
        begin
          opts.parse(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
