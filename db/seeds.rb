# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
Status.create([ { :id => 1, :name => 'Up', :css => 'up' },
                { :id => 2, :name => 'Down', :css => 'down' }, 
                { :id => 3, :name => 'Disabled', :css => 'disabled' }, 
                { :id => 4, :name => 'Unknown', :css => 'unknown' },
                { :id => 5, :name => 'Warning', :css => 'warning'} ])
                
ResponseCode.create([ { :id => 1, :code => 200, :name => 'OK' },
                      { :id => 2, :code => 301, :name => 'Moved Permanently' },
                      { :id => 3, :code => 302, :name => 'Found (Moved Temporarily)' },
                      { :id => 4, :code => 307, :name => 'Moved Temporarily' },
                      { :id => 5, :code => 400, :name => 'Bad Request' },
                      { :id => 6, :code => 401, :name => 'Unauthorized' },
                      { :id => 7, :code => 403, :name => 'Forbidden' },
                      { :id => 8, :code => 404, :name => 'Not Found' },
                      { :id => 9, :code => 500, :name => 'Internal Server Error' },
                      { :id => 10, :code => 502, :name => 'Bad Gateway' },
                      { :id => 11, :code => 503, :name => 'Service Unavailable' }])

