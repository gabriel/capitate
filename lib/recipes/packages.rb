namespace :packages do
  
  desc "Remove, update and install packages"
  task :install do
    
    # Settings
    fetch(:packages_type)
    fetch(:packages_add)
    fetch(:pacakges_remove)
    
    # Set package type
    package.type = packages_type
    
    # Remove packages          
    package.remove(packages_remove) unless packages_remove.blank?
    
    # Update all existing packages
    package.update
    
    # Install packages
    package.install(packages_to_add) unless packages_add.blank?
  end
  
end