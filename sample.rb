require 'rubygems'
require 'geocoder'
require 'mongo'
db = Mongo::Connection.new.db("mydb")
coll = db.collection("places")

File.open("smaller.txt").each do |line|
  #s = Geocoder.search(line).first
  s = s.strip().split(",")
  address = s[10]+", "+s[1]
  latitude = s[8]
  longitude = s[9]
  p = {"place" => address, "coordinates" => [latitude, longitude]}
  coll.insert(p)
end
