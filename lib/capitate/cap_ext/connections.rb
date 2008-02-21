# Patch to add ability to clear sessions/connections.
module Capistrano::Configuration::Connections
  
  # Set the user to something new (but save the old user; reset_user will set it back).
  # Takes care of invalidating current connections. Will force a re-login.
  # 
  # ==== Options
  # +new_user+:: User to become
  #
  # ==== Examples
  #   set_user("nginx")
  #   # Do something as user nginx
  #
  def set_user(new_user)
    backup_user = fetch(:user)
    
    return if backup_user == new_user
    @backup_user = backup_user
    
    set :user, new_user
    clear_sessions
  end
  
  # Reset to the old user.
  # Takes care of invalidating current connections. Will force a re-login.
  # 
  # ==== Examples
  #   # User is "root"
  #   set_user("nginx")
  #   # Do something as user nginx
  #   reset_user
  #   # User is now root
  #
  def reset_user
    set :user, @backup_user
    @backup_user = nil
    clear_sessions
  end
  
  # Yields the previous user.
  #
  # ==== Options
  # +new_user+:: User to become
  #
  # ==== Examples
  #   new_user("nginx") do |old_user|
  #     # Do something as user nginx
  #   end
  #   # Now as user old_user
  #
  def with_user(new_user, &block)
    begin
      set_user(new_user)
      yield @backup_user
    ensure
      reset_user
    end
    
    clear_sessions
  end
  
  # Close all open sessions.
  # Will force user to re-login.
  def clear_sessions    
    sessions.each do |key, session|
      logger.info "Closing: #{key}"
      session.close
    end    
    sessions.clear    
    reset_password
  end
  
  # Reset the password.
  # Display the current user that is asking for the password.
  def reset_password
    set :password, Proc.new {
      Capistrano::CLI.password_prompt("Password (for user: #{user}): ")
    }
  end
    
end

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