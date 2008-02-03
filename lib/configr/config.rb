require 'yaml'
require 'highline'

# Configuration class for composition of hash from yaml config
class Configr::Config
  
  attr_accessor :application, :user, :deploy_to, :web_host
  attr_accessor :db_host, :db_user, :db_pass, :db_name, :db_port
  attr_accessor :sphinx_port, :sphinx_host
  attr_accessor :repository, :recipes
  attr_accessor :mongrel_port, :mongrel_size
  attr_accessor :domain_name
  attr_accessor :version
  
  # Increment this version whenever you make non-backwards compatible changes; It will force an configr update.
  Version = 9
  
  def initialize
  end

  # Expose the binding
  def get_binding
    binding
  end
  
  def ask(message, property, answer_type = String, &block)
    result = HighLine.new.ask(message, answer_type) { |q| 
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
    File.open(path, "w") { |f| f.puts self.to_yaml }
  end
  
  # Build config from asking
  def ask_all(configr_yml_path)
    ask("Application name: ", "application")
    set_default("user", application)
    ask("User (to run application as):", "user")
    set_default("deploy_to", "/var/www/apps/#{application}")
    ask("Deploy to:", "deploy_to")    
    ask("Web host:", "web_host")
    
    ask("Database host:", "db_host")    
    set_default("db_user", user)
    ask("Database user:", "db_user")
    ask("Database password:", "db_pass")
    set_default("db_name", application)
    ask("Database name:", "db_name")
    set_default("db_port", 3306)
    ask("Database port:", "db_port", Integer)
    
    set_default("sphinx_host", "127.0.0.1")
    ask("Sphinx host:", "sphinx_host")
    set_default("sphinx_port", 3312)
    ask("Sphinx port:", "sphinx_port", Integer)
    
    default_repos = YAML.load(`svn info`)["URL"] rescue nil
    set_default("repository", default_repos)        
    ask("Repository uri:", "repository")
    
    ask("Mongrel starting port:", "mongrel_port", Integer)
    ask("Number of mongrels:", "mongrel_size", Integer)
    
    ask("Domain name (for nginx vhost; no www prefix):", "domain_name")    
    
    # Load default recipes if not set
    set_default("recipes", YAML.load_file(File.dirname(__FILE__) + "/recipes.yml"))
    
    # Default recipes
    version = Configr::Config::Version
    
    save(configr_yml_path)
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