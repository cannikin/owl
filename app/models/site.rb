class Site < ActiveRecord::Base
  
  has_many :watches, :dependent => :destroy
  
end
