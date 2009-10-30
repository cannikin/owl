class Watch < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :status
  has_many :responses, :dependent => :destroy
  
  named_scope :active, :conditions => { :active => true }
  
  before_save :set_status
  
  private
    
    def set_status
      unless self.active
        self.status_id = Status::DISABLED
      end
    end
end
