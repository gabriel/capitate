# Patch to add ability to clear sessions/connections.
module Capitate
  module CapExt
    module Connections
  
      def self.included(base) #:nodoc:
        base.send :alias_method, :execute_on_servers_without_capitate, :execute_on_servers
        base.send :alias_method, :execute_on_servers, :execute_on_servers_with_capitate
      end
  
      # Determines the set of servers within the current task's scope and
      # establishes connections to them, and then yields that list of
      # servers.
      #
      # Overriden to handle NoMatchingServersError as NON-FATAL
      #  
      def execute_on_servers_with_capitate(options={}, &block)
        begin
          execute_on_servers_without_capitate(options, &block)
        rescue Capistrano::NoMatchingServersError => e
          logger.important "`#{current_task.fully_qualified_name}' is only run for servers matching #{current_task.options.inspect}, but no servers matched"
        end
      end
  
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
        previous_user = fetch(:user)
    
        return if previous_user == new_user
        set :previous_user, previous_user
    
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
        return unless exists?(:previous_user)
        set :user, fetch(:previous_user)
        unset :previous_user
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
          yield exists?(:previous_user) ? fetch(:previous_user) : nil
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
  end
end

# Debug connections
class Capistrano::SSH
  
  class << self  
  
    def connect_with_logging(server, options={}, &block)      
      @connect_mutex ||= Mutex.new
      
      @connect_mutex.synchronize do
        puts "--- Connecting to #{server} with user: #{server.user || options[:user]}"      
      end

      connect_without_logging(server, options, &block)      
    end
  
    alias_method_chain :connect, :logging
  
  end
end