module Capigen
  module CapExt
    module Variables

      def self.included(base) #:nodoc:
        base.send :alias_method, :fetch_without_capigen, :fetch
        base.send :alias_method, :fetch, :fetch_with_capigen
      end
    
      # Fetch (alias method chained) variable.
      # Displays usage message from recipe docs if variable not found.
      #
      # See capistrano fetch for usage info.
      #
      # Recipe docs are in lib/doc/the_namespace.yml
      #
      def fetch_with_capigen(variable, *args)
        begin
          fetch_without_capigen(variable, *args)
        rescue IndexError
          message = capigen.usage(variable)

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
        begin
          return fetch(variable, *args)
        rescue IndexError
          set variable, default
        end
        default
      end
    
    end
  end
  
end
    