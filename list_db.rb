require 'rubygems'  # not necessary for Ruby 1.9
require 'mongo'

connection = Mongo::Connection.new # (optional host/port args)
connection.database_names.each { |name| puts name }
connection.database_info.each { |info| puts info.inspect}
