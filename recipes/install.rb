namespace :install do
  
  task :default do
    # Choose profile, and load capistrano settings
    fetch(:profile)
    
    # Setup packager
    setup_packager(packager_type)
    
    # Remove packages          
    package_remove(packages_to_remove)
    
    # Update all existing packages
    package_update
    
    # Install packages
    package_install(packages_to_add)
    
    # These run after install task and install all the apps
    install_tasks.each do |task_name|
      after "install", task_name
    end
  end
  
end