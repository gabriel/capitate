namespace :packages do
  
  desc <<-DESC
  Remove, update and install packages.
  packages_type: Package manager type. Currently can only be :yum. TODO: Support more package managers.
  
    set :packages_type, :yum
    
  packages_remove: Packages to remove.  
    
    set :packages_remove, [ "openoffice.org-*", "ImageMagick" ]
    
  packages_add: Packages to add.    
  
    set :packages_add, [ "gcc", "kernel-devel", "libevent-devel", "libxml2-devel" ]
    
  DESC
  task :install do
    
    # Settings
    fetch(:packages_type)
    fetch(:packages_add)
    fetch(:packages_remove)
    
    # Set package type
    package.type = packages_type
    
    # Remove packages          
    package.remove(packages_remove) unless packages_remove.blank?
    
    # Update all existing packages
    package.update
    
    # Install packages
    package.install(packages_add) unless packages_add.blank?
  end
  
end