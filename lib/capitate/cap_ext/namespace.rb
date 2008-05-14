module Capitate
  
  module CapExt
    
    module Namespace
      
      def self.included(base) #:nodoc:
        unless base.method_defined?(:task_without_capitate)
          base.send :alias_method, :task_without_capitate, :task
          base.send :alias_method, :task, :task_with_capitate
        end
      end
      
      def task_arg(name, desc, options = {})
        @next_task_arguments ||= []
        @next_task_arguments << options.merge({ :name => name, :desc => desc })
      end
      
      def task_with_capitate(name, options={}, &block)
        task_without_capitate(name, options) do
          find_task(name).setup_defaults
          block.call
        end
        task_def = find_task(name)        
        task_def.arguments = @next_task_arguments
        @next_task_arguments = nil
        task_def
      end
            
    end
    
  end
  
end