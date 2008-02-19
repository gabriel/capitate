# Packages must respond to update, remove, install and clean
module Capitate::Plugins::Yum
  
  # Update all installed packages.
  #
  # ==== Options
  # +packages+:: Packages to update, or empty to update all
  #
  # ==== Examples
  #   yum.update
  #   yum.update([ "aspell" ])
  #
  # Also can use package plugin with package.type = :yum, and then:
  #   package.update
  #   package.update([ "aspell" ])
  #
  def update(packages = [])
    sudo "yum -y update #{packages.join(" ")}"
  end
    
  # Remove via yum.
  #
  # ==== Options
  # +packages+:: Packages to remove
  #
  # ==== Examples
  #   yum.remove
  #   yum.remove([ "aspell" ])
  #
  # Also can use package plugin with package.type = :yum, and then:
  #   package.remove
  #   package.remove([ "aspell" ])
  #  
  def remove(packages)
    sudo "yum -y remove #{packages.join(" ")}"    
  end
  
  # Install via yum.
  # 
  # ==== Options
  # +packages+:: Packages to install, either String (for single package) or Array
  # +update_existing+:: If package exists, where to yum update it, defaults to true
  #  
  # ==== Examples
  #   yum.install
  #   yum.install([ "aspell" ])
  #
  # Also can use package plugin with package.type = :yum, and then:
  #   package.install
  #   package.install([ "aspell" ])
  #    
  def install(packages, update_existing = true)    
    
    # If a single object, wrap in array
    packages = [ packages ] unless packages.is_a?(Array)
    
    if update_existing
      
      installed_packages = []
      
      sudo "yum -d 0 list installed #{packages.join(" ")}" do |channel, stream, data|
        installed_packages += data.split("\n")[1..-1].collect { |line| line.split(".").first }
      end      
    
      packages -= installed_packages
    
      sudo "yum -y update #{installed_packages.join(" ")}" unless installed_packages.blank?
    end
    
    sudo "yum -y install #{packages.join(" ")}" unless packages.blank?
  end
  
  # Clean yum.
  #
  # ==== Examples
  #   yum.clean
  #
  # Also can use package plugin with package.type = :yum, and then:
  #   package.clean
  #
  def clean
    sudo "yum -y clean all"
  end
  
end

Capistrano.plugin :yum, Capitate::Plugins::Yum