require 'rubygems'
require 'geocoder'
require 'mongo'
db = Mongo::Connection.new.db("mydb")
coll = db.collection("places")

File.open("smaller.txt").each do |line|
  s = Geocoder.search(line).first
  p = {"place" => line, "coordinates" => [s.latitude, s.longitude]}
  coll.insert(p)
  puts s[0].latitude
end
