# Package, Yum capistrano helpers
module Capigen::Helpers::PackageHelper
  
  def setup_packager(packager)
    @packager = case packager.to_sym
    when :yum then Capigen::Packagers::Yum.new(self)
    end      
  end
  
  def ensure_packager    
    unless @packager
      logger.important "No packager defined, defaulting to yum." 
    
      # Currently only have 1 packager, so 
      setup_packager(:yum)
    end
  end
  
  def package_install(packages)
    ensure_packager
    @packager.install(packages)
  end
  
  def package_update(packages = [])
    ensure_packager
    @packager.update(packages)
  end
  
  def package_clean
    ensure_packager
    @packager.clean
  end
  
  def package_remove(packages)
    ensure_packager
    @packager.remove(packages)
  end
  
  
end