
# Path to include our helpers for cap recipes
# This is where capistrano is really stupid with its rake-like-but-not-rake syntax
class Capistrano::Configuration::Namespaces::Namespace
  
  # Load config helper for use within recipes
  require File.dirname(__FILE__) + "/../init"
  include Configr::ConfigHelper
  include Configr::Tasks
    
end


# Patch to add ability to clear sessions
module Capistrano::Configuration::Connections
  
  def clear_sessions
    @sessions = {}
  end
  
end
