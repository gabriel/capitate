namespace :packages do
  
  task :install do
    
    # Settings
    packages = profile.get(:packages)
    
    packages_to_remove = packages[:remove]
    packages_to_add = packages[:add]
    
    # Set package type
    package.type = packages[:type]
    
    # Remove packages          
    package.remove(packages_to_remove) unless packages_to_remove.blank?
    
    # Update all existing packages
    package.update
    
    # Install packages
    package.install(packages_to_add) unless packages_to_add.blank?
  end
  
end