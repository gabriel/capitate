# Configr tasks for setup, clean and bootstrap
module Configr::Tasks
  
  include Configr::ConfigHelper
  
  # Run the configr setup task.
  # This generates your capistrano configuration, and any other local project specific stuff (like database.yml, sphinx.conf, etc)
  def task_setup    
    config_path = relative_to_root("config/configr.yml")
    
    if !File.exist?(config_path)
      puts <<-EOS
      
        The config/configr.yml files was not found. You need to setup your configuration.
        
      EOS
      do_bootstrap = HighLine.new.agree("Would you like to create and setup your config/configr.yml?")
      if do_bootstrap
        Rake::Task["configr:bootstrap"].invoke 
      else
        exit 1
      end
    end
        
    config_binding = load_binding_from_config(config_path)
    write_template("capistrano/Capfile.erb", config_binding, relative_to_root("Capfile"), true)    
    #write_template("rails/database.yml.erb", config_binding, relative_to_root("config/database.yml"))
    #write_template("sphinx/sphinx.conf.erb", config_binding, relative_to_root("config/sphinx.conf"))
    
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
  def task_bootstrap(config = nil, auto_default = false)
    config ||= Configr::Config.new
    config.ask_all(configr_yml_path)    
    puts "%10s %-40s" % [ "create", "config/configr.yml" ] 
  end
  
end