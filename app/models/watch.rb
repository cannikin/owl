class Watch < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :status
  has_many :responses, :dependent => :destroy
  
  named_scope :active, :conditions => { :active => true }
  
  before_save :set_status
  
  DEFAULT_INTERVAL = 10.minutes
  DEFAULT_COUNT = 10
  
  # Computes the standard deviation for the last response time of this watch compared to a certain number of checks in the past.
  # By default we look at the average of the last 10 ten minute spans
  def from_average(interval=DEFAULT_INTERVAL, count=DEFAULT_COUNT)
    # puts interval
    averages = []
    1.upto(count) do |i|
      averages << Response.average(:time, :conditions => ['watch_id = ? and time != 0 and created_at < ? and created_at > ?', self.id, (Time.zone.now-(interval*i)).to_s(:db), (Time.zone.now - (interval*i+interval)).to_s(:db)]).to_i
    end
    averages.reject! { |x| x == 0 }   # remove 0 values
    average = averages.inject(nil) { |sum,x| sum ? sum + x : x } / averages.length
    logger.debug("  *** averages: #{averages.inspect}, average: #{average}, last_response_time: #{self.last_response_time}")
    return average.to_f / self.last_response_time.to_f * 100.0
  end
  
  private
    
    def set_status
      unless self.active
        self.status_id = Status::DISABLED
      end
    end
    
end
