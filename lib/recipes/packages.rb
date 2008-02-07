namespace :packages do
  
  task :install do
    
    # Setup packager
    setup_packager(packager_type)
    
    # Remove packages          
    package_remove(packages_to_remove)
    
    # Update all existing packages
    package_update
    
    # Install packages
    package_install(packages_to_add)
    
  end
  
end