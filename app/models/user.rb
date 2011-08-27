class User
  include MongoMapper::Document

  key :name, String
  key :location, String
  
  many :authorizations

  scope :find_by_authorization, lambda {|provider, uid| where('authorizations.provider' => provider, 'authorizations.uid' => uid)}

  def self.create_with_omniauth(auth)  
    user = User.new(:name => auth["user_info"]["name"], :location => auth["user_info"]["location"])
    user.authorizations.push(Authorization.new(:provider => auth["provider"], :uid => auth["uid"]))
    user.save
    return user
  end 

end
