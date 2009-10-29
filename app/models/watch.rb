class Watch < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :status
  has_many :responses, :dependent => :destroy
  
  named_scope :active, :conditions => { :active => true }
  
end
