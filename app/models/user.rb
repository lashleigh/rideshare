class User
  include MongoMapper::Document

  key :name, String
  key :nickname, String
  key :location, String
  key :email, String
  key :website, String
  key :description, String
  key :image, String
  timestamps!
  
  many :authorizations
  many :trips

  #scope :find_by_authorization, lambda {|provider, uid| where('authorizations.provider' => provider, 'authorizations.uid' => uid)}
  def self.create_with_omniauth(auth)  
    user = User.new(:name => auth["user_info"]["name"], 
                    :nickname => auth["user_info"]["nickname"],
                    :location => auth["user_info"]["location"], 
                    :email => auth["user_info"]["email"],
                    :website => auth["user_info"]["urls"].first.last,
                    :description => auth["user_info"]["description"],
                    :image => auth["user_info"]["image"]
                   )
    user.authorizations.push(Authorization.new(:provider => auth["provider"], :uid => auth["uid"]))
    user.save
    return user
  end 

  def self.find_by_authorization(provider, uid)
    u = where('authorizations.provider' => provider, 'authorizations.uid' => uid).first
    u.save if u
    return u
  end
  def add_authorization(provider, uid)
    self.authorizations.push(Authorization.new(:provider => provider, :uid => uid))
  end
  def vcard_attributes(options={})
    options[:include] ||= ["name", "location", "website"]
    vcard_attr = self.attributes.select {|k, v|  options[:include].include? k and v !=nil}
    vcard_attr["member_since"] = self.created_at.to_date.to_formatted_s(:long_ordinal)
    return vcard_attr
  end
  def stats_attributes(options={})
  
  end

end
