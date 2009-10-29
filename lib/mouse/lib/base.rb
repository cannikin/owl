module Crawler
  class Base
    
    def initialize(keyword)
      @keyword = keyword
      @entries = []
      Crawler.logger.debug("\n  #{self.class} initialized with '#{@keyword}'")
    end
    
    # Throws an error if not extended (this is the method that actually knows how to go out
    # and get results, then parse them into a standard format
    def go
      raise "Override me! I'm the method that goes out to the service and parses results. I should return a hash with data to insert into the database - { 
              :foreign_id => The service's id for this entry (used to check for duplicates),
              :user => Name of the user that created this entry,
              :user_url => URI to a user's profile on the service,
              :avatar => URI to the user's avatar image,
              :text => The text of this entry,
              :validate_text => The text to check against the rules,
              :text_url => URI to this entry on the interwebs"
    end

    # Returns the data that the crawler found in a standard format
    def to_s
      @entries.inspect
    end
  end
end
