class Watch < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :status
  has_many :responses, :dependent => :destroy
  
  named_scope :active, :conditions => { :active => true }
  
  before_save :set_status
  
  DEFAULT_INTERVAL = 1.hour
  DEFAULT_COUNT = 10
  
  
  # Computes the standard deviation for the last response time of this watch compared to a certain number of checks in the past.
  # By default we look at the average of the last 10 ten minute spans
  def from_average(interval=DEFAULT_INTERVAL)
    average = Response.average(:time, :conditions => ['watch_id = ? and time != 0 and created_at < ? and created_at > ?', self.id, Time.zone.now.to_s(:db), (Time.zone.now-interval).to_s(:db)]).to_i
    logger.debug("  *** average: #{average}, last_response_time: #{self.last_response_time}")
    return (average == 0 || last_response_time == 0) ? nil : (average.to_f / self.last_response_time.to_f * 100.0).to_i
  end
  
  
  # Says how long we've been in the current state (either last_status_update_at or created_at)
  def since
    return self.last_status_change_at.nil? ? self.created_at.to_s(:javascript) : self.last_status_change_at.to_s(:javascript)
  end
  
  
  private
    
    def set_status
      unless self.active
        self.status_id = Status::DISABLED
      end
    end
    
end
