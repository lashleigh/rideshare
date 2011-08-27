class Authorization
  include MongoMapper::EmbeddedDocument

  key :uid, String
  key :provider, String

  belongs_to :user

end
