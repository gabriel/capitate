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
  def update(packages = [])
    run_via "yum -y update #{packages.join(" ")}"
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
  def remove(packages)
    run_via "yum -y remove #{packages.join(" ")}"    
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
  def install(packages, update_existing = true)    
    
    # If a single object, wrap in array
    packages = [ packages ] unless packages.is_a?(Array)
    
    if update_existing
      
      installed_packages = []
      
      run_via "yum -d 0 list installed #{packages.join(" ")}" do |channel, stream, data|
        lines = data.split("\n")[1..-1]
        if lines.blank?
          logger.info "Invalid yum output: #{data}"
        else
          installed_packages += lines.collect { |line| line.split(".").first }
        end
      end      
    
      packages -= installed_packages
    
      run_via "yum -y update #{installed_packages.join(" ")}" unless installed_packages.blank?
    end
    
    run_via "yum -y install #{packages.join(" ")}" unless packages.blank?
  end
  
  # Clean yum.
  #
  # ==== Examples
  #   yum.clean
  #
  def clean
    run_via "yum -y clean all"
  end
  
end

Capistrano.plugin :yum, Capitate::Plugins::Yum