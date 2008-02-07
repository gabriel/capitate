# Packages must respond to update, remove, install and clean
class Capigen::Packagers::Yum
  
  def initialize(cap)
    @cap = cap
  end
  
  # Update all installed packages
  def update(packages = [])
    @cap.sudo "yum -y update #{packages.join(" ")}"
  end
    
  # Remove via yum.
  def remove(packages)
    @cap.sudo "yum -y remove #{packages.join(" ")}"    
  end
  
  # Install via yum.
  # If package already exists, it will be updated (unless update_existing = false).
  def install(packages, update_existing = true)    
    
    # If a single object, wrap in array
    packages = [ packages ] unless packages.is_a?(Array)
    
    if update_existing
      
      installed_packages = []
      
      @cap.sudo "yum -d 0 list installed #{packages.join(" ")}" do |channel, stream, data|
        installed_packages += data.split("\n")[1..-1].collect { |line| line.split(".").first }
      end      
    
      packages -= installed_packages
    
      @cap.sudo "yum -y update #{installed_packages.join(" ")}" unless installed_packages.blank?
    end
    
    @cap.sudo "yum -y install #{packages.join(" ")}" unless packages.blank?
  end
  
  # Clean yum
  def clean
    @cap.sudo "yum -y clean all"
  end
  
end