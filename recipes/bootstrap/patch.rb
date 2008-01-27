#
# Patches
#

class Capistrano::Configuration::Namespaces::Namespace
  
  # Load config helper for use within recipes
  require File.dirname(__FILE__) + "/../../init"
  include Configr::ConfigHelper
  include Configr::Helpers::Yum
  include Configr::Helpers::Wget
  include Configr::Helpers::InstallScript
      
end

class Capistrano::Configuration
  # Load config helper for use within Capfile
  require File.dirname(__FILE__) + "/../../init"
  include Configr::ConfigHelper

end


# Patch to add ability to clear sessions
module Capistrano::Configuration::Connections
  
  def set_user(new_user)
    backup_user = fetch(:user)
    
    return if backup_user == new_user
    @backup_user = backup_user
    
    set :user, new_user
    clear_sessions
  end
  
  def reset_user
    set :user, @backup_user
    clear_sessions
  end
  
  def with_user(new_user, &block)
    begin
      set_user(new_user)
      yield      
    ensure
      reset_user
    end
    
    clear_sessions
  end
  
  def clear_sessions
    logger.info "Clearing sessions..."
    @sessions = {}
  end
  
end