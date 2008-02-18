namespace :packages do
  
  desc "Packages to install"
  task :install do
    
    # Settings
    packages = profile.get(:packages, <<-EOS)
      
      To use this recipe, set the :packages variable (in a profile, Capfile or deploy.rb), for example:
      
      set :packages, { 
        :type => "yum",
        :remove => [ "openoffice.org-*", "ImageMagick" ],
        :add => [ "gcc", "kernel-devel", "libevent-devel", "libxml2-devel" ]
      }
      
    EOS
    
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