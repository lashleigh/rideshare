
File.open("smaller.txt").each do |line|; p = Place.new; s = line.strip().split(","); p.address = s[10]+", "+s[1]; p.coords[0] = s[8].strip(); p.coords[1] = s[9].strip(); p.save; end
