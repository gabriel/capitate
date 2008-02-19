class Capistrano::ExtensionProxy 
  
  # Allow ability to include modules in plugins.
  #
  # ==== Options
  # +mod+:: Module
  #
  # ==== Examples
  #   include Capitate::Plugins::Yum
  #
  def include(mod)
    self.class.send(:include, mod)
  end
  
end