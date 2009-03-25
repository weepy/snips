# Snipz
require 'digest/sha1'

module Snips
  
  #AUTHENTICATION
  @@user_digest = nil
  class << self
    def should_auth
      @@user_digest
    end
    
    def logout
      @@user_digest = nil
    end

    def digest(user, pass)
      Digest::SHA1.hexdigest(user.to_s + pass.to_s)
    end
  
    def protect(user, pass)
      @@user_digest = digest(user, pass)
    end

    def auth(user, pass)
      return @@user_digest if digest(user, pass) == @@user_digest
      false
    end

    def check_digest(digest)
      @@user_digest == digest
    end
    
  end
  
  #LAYOUTS
  @@layouts = [nil]
  
  def self.layouts
    @@layouts
  end
  
  def self.enumerate_layouts(path)
    
    layouts = Dir.entries(path).delete_if do |x| 
        c = x.slice(0,1); 
        c == "." || c == "_"
      end.map do |x|
        x.gsub(".erb","").gsub(".haml","").gsub(".html","").gsub(".rhtml","")
      end
      
    @@layouts =  [nil] + layouts
  end
  

end
