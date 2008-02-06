namespace :gen do
  
  desc "Generate Capfile and deploy.rb"
  task :default do
    # auto_default = false
    
    config = Configr::Config.new
    config.ask_all
        
    config_binding = config.get_binding
    write_template("capistrano/Capfile", config_binding, relative_to_root("Capfile"), true)    
    write_template("capistrano/deploy.rb.erb", config_binding, relative_to_root("config/deploy.rb"))
  end
    
end