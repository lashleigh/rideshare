Rails.application.config.middleware.use OmniAuth::Builder do  
  #provider :foursquare, 'LNKOBIXNHL0UWSYGJIX5K1Q1N0NZ4CHNB0N4G1RHT4RKW4FI', 'NGNH3G1XPHK0YUQV2PMMJO02F14JBDBOM2IM1M1Z5NFB5O0T'  
  provider :twitter, 'eLer2w1Kr1lJzd1jXYopDg', 'yNtwmkijeNQhEaiyRDxqeNjNWJ8EiufclOuVFqjSw'
  #provider :open_id, OpenID::Store::Filesystem.new('/tmp')
end 
