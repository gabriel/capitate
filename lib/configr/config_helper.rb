require 'erb'
require 'yaml'

# == Configuration helpers
#
# * Loads the configuration 
# * Generates files from templates
#
module Configr::ConfigHelper
  
  include Configr::Templates
  include Configr::Profiles
  
  include Configr::Helpers::YumHelper
  include Configr::Helpers::WgetHelper
  include Configr::Helpers::ScriptHelper
  include Configr::Helpers::GemHelper
    
  # Project root (for rails)
  def root
    if respond_to?(:fetch)
      return fetch(:project_root)
    end
    
    RAILS_ROOT
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
        
        This is loaded for the configr plugin. View the README in:
        #{File.expand_path(File.dirname(__FILE__) + "/../doc/README")}
      EOS
    end
    
    root_path
  end  
  
  # The default path to the configr yaml.
  def configr_yml_path
    @configr_yml_path ||= "#{root}/config/configr.yml"
  end
  
  def config
    @config ||= YAML.load_file(configr_yml_path)
  end
  
  # Check for config file and a good version
  def check_config
    return load_config_yaml.check_version if File.exist?(configr_yml_path)
    false
  end
  
  # Load binding from the config object (generated from the configr yaml)
  def load_binding_from_config(path)
    config = YAML.load_file(path)
    config.get_binding
  end
  
end

