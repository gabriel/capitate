module Capitate
  
  module CapExt
    
    module TaskDefinition
      
      attr_accessor :arguments
      
      def setup_defaults
        return if arguments.blank?
        
        arguments.each do |arg|
          namespace.fetch_or_default(arg[:name], arg[:default]) if arg.has_key?(:default)
          namespace.fetch_or_set(arg[:name], arg[:set]) if arg.has_key?(:set)
        end 
      end
      
    end
    
  end
  
end