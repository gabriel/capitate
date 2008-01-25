# Configr tasks for setup, clean and bootstrap
module Configr::Tasks
  
  include Configr::ConfigHelper
  include Configr::Prompt  
  
  # Run the setup task
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
    write_template("capistrano/Capfile.erb", config_binding, relative_to_root("Capfile"))    
    write_template("capistrano/deploy.rb.erb", config_binding, relative_to_root("config/deploy.rb"))
    write_template("rails/database.yml.erb", config_binding, relative_to_root("config/database.yml"))
    write_template("sphinx/sphinx.conf.erb", config_binding, relative_to_root("config/sphinx.conf"))
    
  end
  
  # Run the clean task
  def task_clean 
    clean("Capfile")
    clean("config/deploy.rb")
    clean("config/database.yml")
    clean("config/sphinx.conf")
    
    if prompt_yes_no("Do you want to delete the configr.yml?", false) && File.exist?(relative_to_root("config/configr.yml"))
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
  # This elps create the configr.yml (prompts for user input)
  # Alternatively you can create the yaml manually.
  #
  # Example,
  #
  #   application: testapp
  #   user: testapp
  # 
  #   deploy_to: "/var/www/apps/testapp"
  #   web_server: 10.0.6.159
  #   db_server: 10.0.6.159
  # 
  #   db_user: testapp
  #   db_pass: testapp
  #   db_name: testapp
  #
  #   mongrel_port: 9000
  #   mongrel_size: 3
  #
  #   repository: http://foo.com/var/svn/testapp/trunk
  #
  #   domain_name: foo.com
  # 
  #   recipes:
  #     - database
  #     - mongrel_cluster
  #     - sphinx
  #
  def task_bootstrap(defaults = {}, auto_default = false)
    config = {}.merge(defaults)
    
    config["application"] = prompt_with_example("Application name", "myapp", config["application"], auto_default).underscore
    config["user"] = prompt_with_default("User", config["user"] || config["application"], auto_default)
    config["deploy_to"] = prompt_with_default("Deploy to", config["deploy_to"] || "/var/www/apps/#{config["application"]}", auto_default)
    config["web_server"] = prompt_with_default("Web server", config["web_server"] || "10.0.6.159", auto_default)
    config["db_server"] = prompt_with_default("Database server", config["db_server"] || "10.0.6.159", auto_default)
    config["db_user"] = prompt_with_default("Database user",config["db_user"] || config["user"], auto_default)
    config["db_pass"] = prompt_with_default("Database password", config["db_pass"], auto_default)
    config["db_name"] = prompt_with_default("Database name", config["db_name"] || config["user"], auto_default)
    
    config["repository"] = prompt_with_example("Repository", "http://foo.com/var/svn/myapp/trunk", config["repository"], auto_default)
    
    config["mongrel_port"] = prompt_with_example("Mongrel starting port", "9000", config["mongrel_port"], auto_default)
    config["mongrel_size"] = prompt_with_example("Number of mongrels", "3", config["mongrel_size"], auto_default)
    
    config["domain_name"] = prompt_with_example("Domain name (for nginx, no www prefix)", "foo.com", config["domain_name"], auto_default)
    
    # Default recipes
    config["recipes"] = [ "database", "mongrel_cluster", "sphinx", "nginx" ]
    
    config["version"] = Configr::Config::Version
    
    File.open(configr_yml_path, "w") { |f| f.puts config.to_yaml }
    puts "%10s %-40s" % [ "create", "config/configr.yml" ] 
  end
  
protected

  def configr_yml_path
    @configr_yml_path ||= "#{RAILS_ROOT}/config/configr.yml"
  end
end