class Watch < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :status
  
end
