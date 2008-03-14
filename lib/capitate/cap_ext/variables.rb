module Capitate
  module CapExt
    module Variables

      def self.included(base) #:nodoc:
        base.send :alias_method, :fetch_without_capitate, :fetch
        base.send :alias_method, :fetch, :fetch_with_capitate
      end
    
      # Fetch (alias method chained) variable.
      # Displays usage message from recipe docs if variable not found.
      #
      # See capistrano fetch for usage info.
      #
      def fetch_with_capitate(variable, *args)
        begin
          fetch_without_capitate(variable, *args)
        rescue IndexError
          message = capitate.usage(variable)

          if message.blank?
            message = <<-EOS

            Please set :#{variable} variable in your Capfile or profile.

            EOS
          end
        
          raise IndexError, "\n#{message}"
        end        
      end
      
      # Fetch or set and return default.
      #
      # ==== Options
      # +variable+:: Variable to fetch
      # +default+:: Default value if not set
      # +args+:: ?
      #
      # ==== Examples
      #   fetch_or_default(:memcached_port, 11211) => 11211
      #   # Any calls to fetch(memcached_port) in the future will return this value 11211 (unless overriden)
      #
      def fetch_or_default(variable, default, *args)
        if exists?(variable)
          fetch(variable, *args)
        else
          set variable, default
          default
        end        
      end
      
      # Fetch or set and fetch any default variable listed.
      #
      # ==== Options
      # +variable+:: Variable to fetch
      # +variables+:: List if variables to try in order
      #
      # ==== Examples
      #   fetch_or_set(:sphinx_db_host, :db_host)
      #
      def fetch_or_set(variable, *default_variables)
        return fetch(variable) if exists?(variable)
        
        default_variables.each do |default_variable|
          if exists?(default_variable)
            value = fetch(default_variable) 
            set variable, value
            return value
          end
        end
        nil        
      end
      
      # Fetch roles with name and options
      # I don't actually use this.
      #
      # ==== Options
      # +name+:: Role name to look for
      # +options+:: Options to match on, e.g. :primary => true
      #
      # ==== Examples
      #   fetch_roles(:db) => [ "10.0.6.71", "10.0.6.72" ]
      #   fetch_roles(:db, :primary => true) => [ "10.0.6.71" ]
      #
      def fetch_roles(name, options = {})
        matched_roles = Set.new
        
        roles.each do |role_info|
          role_name = role_info.first 
          
          next unless role_name == name
            
          role = role_info.last
          role.each do |server|
            
            abort = false
            options.each do |k, v|
              unless server.options[k] == v
                abort = true
                break 
              end
            end
            next if abort
            
            matched_roles << server
          end
        end
        matched_roles.to_a
      end
      
      # Fetch first role with name and options.
      #
      # ==== Options
      # +name+:: Role name to look for
      # +options+:: Options to match on, e.g. :primary => true
      #
      # ==== Examples
      #   fetch_roles(:db) => [ "10.0.6.71", "10.0.6.72" ]
      #   fetch_roles(:db, :primary => true) => [ "10.0.6.71" ]
      #
      def fetch_role(name, options = {})
        matched = fetch_roles(name, options)
        return matched.first if matched
        nil
      end
    
    end
  end
  
end
    