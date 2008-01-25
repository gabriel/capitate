require 'yaml'

# Configuration class for composition of hash from yaml config
class Configr::Config
  
  attr_accessor :application, :user, :deploy_to, :web_server, :db_server
  attr_accessor :db_user, :db_pass, :db_name
  attr_accessor :repository, :recipes
  attr_accessor :mongrel_port, :mongrel_size
  attr_accessor :domain_name
  attr_accessor :version
  
  DefaultRecipes = YAML.load_file(File.dirname(__FILE__) + "/../../config/recipes.yml")
  
  # Increment this version whenever you make non-backwards compatible changes; It will force an configr update.
  Version = 7
  
  # Initialize with hash, all keys used to set instance variable
  def initialize(hash)
    self.class.check_version(hash)
    
    hash.each do |key, value|
      
      unless respond_to?(key.to_sym)
        raise "Config does not handle the method (key): #{key}. You probably need to add an accessor here for it."
      end
      
      instance_variable_set("@#{key}", value)
    end
  end

  # Generates all the callbacks for the Capfile.
  # This is based on the recipes configuration.
  def capfile_callbacks
    callbacks = [ "install", "setup", "update_code" ]
    
    callback_data = []
    
    callbacks.each do |callback|
      recipes[callback].each do |call_when, recipes|
        recipes.each do |recipe|
          callback_data << %{#{call_when} "deploy:#{callback}", "#{recipe}:#{callback}"}
        end
      end
    end
    
    callback_data.join("\n")
  end
    
  def validate
    # TODO-gabe: validate
  end
      
  # Expose the binding
  def get_binding
    binding
  end
  
  class << self
  
    # Return the binding from a config hash
    def binding_from_hash(hash)
      new(hash).get_binding
    end
    
    # Check the version.
    # If out of date, notify to run an update.
    def check_version(hash)
      if hash["version"].blank? || hash["version"] < Version
        puts <<-EOS

        WARNING: The version of you configuration is out of date. Please run rake configr:update.

        EOS
        raise "Config file version of out date"
      end
    end
    
  end
  
end