module Capitate
  module CapExt
    module Roles
      
      def self.included(base) #:nodoc:
        base.send :alias_method, :role_list_from_without_capitate, :role_list_from
        base.send :alias_method, :role_list_from, :role_list_from_with_capitate
      end
      
      def role_list_from_with_capitate(roles)        
        roles = roles.split(/,/) if String === roles
        roles = build_list(roles)
        roles.map { |role|
          role = String === role ? role.strip.to_sym : role
          unless self.roles.key?(role)
            logger.important "unknown role `#{role}'" 
            nil
          else
            role
          end
        }.compact
      end
      
    end
  end
end