# Configuration class for composition of hash from yaml config
class Configr::Config
  
  attr_accessor :application, :user, :deploy_to, :web_server, :db_server
  attr_accessor :db_user, :db_pass, :db_name
  attr_accessor :repository, :recipes
  attr_accessor :mongrel_port, :mongrel_size
  
  def initialize(hash)
    hash.each do |key, value|
      
      unless respond_to?(key.to_sym)
        raise "Config does not handle the method (key): #{key}. You probably need to add an accessor here for it."
      end
      
      instance_variable_set("@#{key}", value)
    end
    
  end
  
  def get_binding
    binding
  end
  
  class << self
    
    def binding_from_hash(hash)
      new(hash).get_binding
    end
    
  end
  
end