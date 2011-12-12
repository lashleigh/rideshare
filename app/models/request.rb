class Request
  include MongoMapper::Document

  key :origin, String
  key :destination, String
  key :title, String
  key :summary, String
  key :url, String
  key :start_date, Time
  belongs_to :craigslist
  belongs_to :user

  def self.from_craigslist(entry, cr, user_id)
    Request.create!({:title => entry.title, 
                     :summary => entry.summary, 
                     :origin => cr.city+','+cr.state,
                     :url => entry.url, 
                     :craigslist_id => cr.id, 
                     :user_id => user_id })
  end

  def migrate
    Trip.create!({:summary => self.title+'\n'+self.summary, 
                  :origin => self.origin,
                  :destination => self.destination,
                  :url => self.url, 
                  :user_id => self.user_id,
                  :start_date => Time.now
    })
  end

end
