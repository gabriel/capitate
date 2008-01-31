require 'yaml'
require 'highline'

# Configuration class for composition of hash from yaml config
class Configr::Config
  
  attr_accessor :application, :user, :deploy_to, :web_server, :db_server
  attr_accessor :db_user, :db_pass, :db_name
  attr_accessor :repository, :recipes
  attr_accessor :mongrel_port, :mongrel_size
  attr_accessor :domain_name
  attr_accessor :version
  
  # Increment this version whenever you make non-backwards compatible changes; It will force an configr update.
  Version = 8
  
  def initialize
  end

  # Expose the binding
  def get_binding
    binding
  end
  
  def ask(message, property, &block)
    result = HighLine.new.ask(message) { |q| 
      q.default = send(property.to_sym)
      yield q if block_given?
    }
    
    send("#{property}=", result)
  end
  
  def set_default(property, value)
    v = send(property.to_sym)
    send("#{property}=", value) if v.blank?
  end
  
  def save(path)
    File.open(path, "w") { |f| f.puts self.to_yaml(:UseHeader => false) }
  end
  
  # Check the version.
  # If out of date, notify to run an update.
  def check_version
    if version.blank? || version < Version
      puts <<-EOS

      WARNING: The version of you configuration is out of date. Please run rake configr:update.

      EOS
      raise "Config file version of out date"
    end
  end
  
end