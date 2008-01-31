# Package, Yum capistrano helpers
module Configr::Helpers::PackageHelper
  
  def setup_packager(packager)
    @packager = case packager.to_sym
    when :yum then Configr::Packagers::Yum.new(self)
    end      
  end
  
  def ensure_packager    
    puts "[WARNING] No packager defined, defaulting to yum." unless @packager
    
    # Currently only have 1 packager, so 
    setup_packager(:yum)
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