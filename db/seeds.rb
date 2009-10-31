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
                