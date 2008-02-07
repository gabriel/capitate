module Capistrano
  class ExtensionProxy #:nodoc:
    
    # Allow include modules in plugins
    def include(mod)
      self.class.send(:include, mod)
    end
    
  end
end