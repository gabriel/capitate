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
  def task_bootstrap
    config = {}
    
    config["application"] = prompt_with_example("Application name", "myapp").downcase
    config["user"] = prompt_with_default("User", config["application"])
    config["deploy_to"] = prompt_with_default("Deploy to", "/var/www/apps/#{config["application"]}")
    config["web_server"] = prompt_with_default("Web server", "10.0.6.159")
    config["db_server"] = prompt_with_default("Database server", "10.0.6.159")
    config["db_user"] = prompt_with_default("Database user", config["user"])
    config["db_pass"] = prompt("Database password")
    config["db_name"] = prompt_with_default("Database name", config["user"])
    
    config["repository"] = prompt_with_example("Repository", "http://foo.com/var/svn/myapp/trunk")
    
    config["mongrel_port"] = prompt_with_example("Mongrel starting port", "9000")
    config["mongrel_size"] = prompt_with_example("Number of mongrels", "3")
    
    config["domain_name"] = prompt_with_example("Domain name (for nginx, no www prefix)", "foo.com")
    
    # Default recipes
    config["recipes"] = [ "database", "mongrel_cluster", "sphinx" ]
    
    configr_yml_path = "#{RAILS_ROOT}/config/configr.yml"
    
    File.open(configr_yml_path, "w") { |f| f.puts config.to_yaml }
    puts "%10s %-40s" % [ "create", "config/configr.yml" ] 
  end
  
end