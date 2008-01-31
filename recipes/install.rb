namespace :install do
  
  task :default do
    profile = fetch(:profile) 
    set :profile, choose_profile unless profile
    
    # Setup packager
    setup_packager(profile["packager"]["type"])
    
    # Remove packages          
    package_remove(profile["packager"]["remove"])
    
    # Update all existing packages
    package_update
    
    # Install packages
    package_install(profile["packager"]["install"])
    
    set :gems, profile["gems"]
    
    # These run after install task and install all the apps
    profile["tasks"].each do |task_name|
      after "#{profile["namespace"]}:install", task_name
    end
  end
  
end