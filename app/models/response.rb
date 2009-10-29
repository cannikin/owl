class Response < ActiveRecord::Base
  
  belongs_to :watch
  has_many :headers, :dependent => :destroy
  
end
