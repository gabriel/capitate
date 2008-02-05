#
# Patches
#

class Capistrano::Configuration::Namespaces::Namespace
  
  # Load config helper for use within recipes
  require File.dirname(__FILE__) + "/../../init"
  include Configr::Helper
      
end

class Capistrano::Configuration
  # Load config helper for use within Capfile
  require File.dirname(__FILE__) + "/../../init"
  include Configr::Helper
  
end


# Patch to add ability to clear sessions
module Capistrano::Configuration::Connections
  
  # Set the user to something new (but save the old user; reset_user will set it back)
  def set_user(new_user)
    backup_user = fetch(:user)
    
    return if backup_user == new_user
    @backup_user = backup_user
    
    set :user, new_user
    clear_sessions
  end
  
  # Reset the old user
  def reset_user
    set :user, @backup_user
    @backup_user = nil
    clear_sessions
  end
  
  # Yields the previous user
  def with_user(new_user, &block)
    begin
      set_user(new_user)
      yield @backup_user
    ensure
      reset_user
    end
    
    clear_sessions
  end
  
  # Close all open session
  def clear_sessions    
    sessions.each do |key, session|
      logger.info "Closing: #{key}"
      session.close
    end    
    sessions.clear    
    reset_password
  end
  
  # Reset the password
  def reset_password
    set :password, Proc.new {
      Capistrano::CLI.password_prompt("Password (for #{user}): ")
    }
  end
  
end

reset_password

# Debug connections
# class Capistrano::SSH
#   
#   class << self  
#   
#     def connect_with_logging(server, options={}, &block)
#       connect_without_logging(server, options, &block)
#     end
#   
#     alias_method_chain :connect, :logging
#   
#   end
# end