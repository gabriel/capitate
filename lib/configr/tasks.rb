# Configr tasks for setup, clean and bootstrap
module Configr::Tasks
  
  include Configr::ConfigHelper
  include Configr::Prompt  
  
  # Run the configr setup task.
  # This generates your capistrano configuration, and any other local project specific stuff (like database.yml, sphinx.conf, etc)
  def task_setup    
    config_path = relative_to_root("config/configr.yml")
    
    if !File.exist?(config_path)
      puts <<-EOS
      
        The config/configr.yml files was not found. You need to setup your configuration.
        
      EOS
      do_bootstrap = prompt_yes_no("Would you like to create and setup your config/configr.yml?")
      if do_bootstrap
        Rake::Task["configr:bootstrap"].invoke 
      else
        exit 1
      end
    end
        
    config_binding = load_binding_from_config(config_path)
    write_template("capistrano/Capfile.erb", config_binding, relative_to_root("Capfile"), true)    
    write_template("rails/database.yml.erb", config_binding, relative_to_root("config/database.yml"))
    write_template("sphinx/sphinx.conf.erb", config_binding, relative_to_root("config/sphinx.conf"))
    
  end
  
  # Run the clean task
  def task_clean 
    clean("Capfile")
    
    if File.exist?(relative_to_root("config/configr.yml")) && prompt_yes_no("Do you want to delete the configr.yml?", false)
      clean("config/configr.yml") 
    end
  end
  
  # Run the update task
  def task_update
    defaults = File.exist?(configr_yml_path) ? YAML.load_file(configr_yml_path) : {}
    task_bootstrap(defaults, true)
  end
  
  # Run the boostrap task.
  #
  # This helps create the configr.yml (prompts for user input)
  # Alternatively you can create the yaml manually.
  #
  def task_bootstrap(defaults = {}, auto_default = false)
    config = {}.merge(defaults)
    
    # Auto-detect repository default, if possible
    unless config["repository"]
      begin
        svn_info = YAML.load(`svn info`)
        config["repository"] = svn_info["URL"] if svn_info
      rescue
        # Couldn't auto-detect repository
      end
    end    
    
    config["application"] = prompt_with_example("Application name", "myapp", config["application"], auto_default).underscore
    config["user"] = prompt_with_default("User", config["user"] || config["application"], auto_default)
    config["deploy_to"] = prompt_with_default("Deploy to", config["deploy_to"] || "/var/www/apps/#{config["application"]}", auto_default)
    config["web_server"] = prompt_with_default("Web server", config["web_server"] || "10.0.6.159", auto_default)
    config["db_server"] = prompt_with_default("Database server", config["db_server"] || "10.0.6.159", auto_default)
    config["db_user"] = prompt_with_default("Database user",config["db_user"] || config["user"], auto_default)
    config["db_pass"] = prompt_with_default("Database password", config["db_pass"], auto_default)
    config["db_name"] = prompt_with_default("Database name", config["db_name"] || config["user"], auto_default)
    
    config["repository"] = prompt_with_default("Repository uri", config["repository"], auto_default)
    
    config["mongrel_port"] = prompt_with_example("Mongrel starting port", "9000", config["mongrel_port"], auto_default).to_i
    config["mongrel_size"] = prompt_with_example("Number of mongrels", "3", config["mongrel_size"], auto_default).to_i
    
    config["domain_name"] = prompt_with_default("Domain name (for nginx vhost; no www prefix)", config["domain_name"] || "localhost", auto_default)
    
    # Load default recipes if not set
    config["recipes"] ||= YAML.load_file(File.dirname(__FILE__) + "/recipes.yml")
    
    # Default recipes
    config["version"] = Configr::Config::Version
    
    File.open(configr_yml_path, "w") { |f| f.puts config.to_yaml }
    puts "%10s %-40s" % [ "create", "config/configr.yml" ] 
  end
  
end