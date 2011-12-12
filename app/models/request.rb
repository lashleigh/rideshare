class Request < Ride

  belongs_to :craigslist
  belongs_to :user

  def self.from_craigslist(entry, cr, user_id)
    Request.create!({:summary => entry.title+"\n\n"+entry.summary[0..entry.summary.index('<!--')-1].gsub('<br>', "\r").strip,
                     :origin => cr.city+','+cr.state,
                     :url => entry.url, 
                     :craigslist_id => cr.id, 
                     :user_id => user_id })
  end

  def migrate
    Trip.new(self.attributes.reject{|k,v| k=== "_id" || k=== "_type"})
    #self.destroy
  end

end
