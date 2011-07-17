
File.open("smaller.txt").each do |line|; p = Place.new; s = line.strip().split(","); p.address = s[10]+", "+s[1]; p.coords = [s[8].to_f, s[9].to_f]; p.save; end
