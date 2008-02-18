require 'erb'
require 'yaml'

# Capigen base capistrano plugin
module Capigen::Plugins::Base
  
  # Project root
  def root
    if respond_to?(:fetch)
      return fetch(:project_root)
    else
      RAILS_ROOT
    end
  end
    
  # Path relative to project root
  def relative_to_root(path = nil, check_exist = false)
    if path
      root_path = File.join(root, path)
    else
      root_path = root
    end
    
    # Check for file existance
    if check_exist and !File.exist?(root_path)
      raise <<-EOS
        
        File not found: #{File.expand_path(root_path)}
        
        This is loaded for the capigen plugin. View the README in:
        #{File.expand_path(File.dirname(__FILE__) + "/../doc/README")}
      EOS
    end
    
    root_path
  end  
    
end

Capistrano.plugin :capigen, Capigen::Plugins::Base