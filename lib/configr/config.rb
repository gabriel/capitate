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
  
  def ask(message, property, options = {}, &block)    
    # Options
    default = options[:default] || nil    
    answer_type = options[:answer_type] || String
    auto_apply = options[:auto_apply]
    
    # Default to existing or default if set
    existing = send(property.to_sym)
    default = existing || default
    
    unless auto_apply and !existing.blank?
      result = HighLine.new.ask(message, answer_type) { |q| 
        q.default = default
        yield q if block_given?
      }
  
      send("#{property}=", result)
    end
  end
  
  def set_default(property, value)
    v = send(property.to_sym)
    send("#{property}=", value) if v.blank?
  end
  
  def save(path)
    File.open(path, "w") { |f| f.puts self.to_yaml }
  end
  
  # Build config from asking
  def ask_all(configr_yml_path, auto_apply = false)
    
    options = { :auto_apply => auto_apply }
    
    ask("Application name: ", "application", options)
    ask("User (to run application as):", "user", options.merge({ :default => application }))
    
    ask("Deploy to:", "deploy_to", options.merge({ :default => "/var/www/apps/#{application}" }))  
    ask("Web host:", "web_host", options)
    
    ask("Database host:", "db_host", options)    
    ask("Database user:", "db_user", options.merge({ :default => user }))
    ask("Database password:", "db_pass", options)
    ask("Database name:", "db_name", options.merge({ :default => application }))

    ask("Database port:", "db_port", options.merge({ :default => 3306, :answer_type => Integer }))
    
    ask("Sphinx host:", "sphinx_host", options.merge({ :default => "127.0.0.1" }))
    ask("Sphinx port:", "sphinx_port", options.merge({ :default => 3312, :answer_type => Integer }))
    
    default_repos = YAML.load(`svn info`)["URL"] rescue nil
    ask("Repository uri:", "repository", options.merge({ :default => default_repos }))
    
    ask("Mongrel starting port:", "mongrel_port", options.merge({ :answer_type => Integer }))
    ask("Number of mongrels:", "mongrel_size", options.merge({ :answer_type => Integer }))
    
    ask("Domain name (for nginx vhost; no www prefix):", "domain_name", options)    
    
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