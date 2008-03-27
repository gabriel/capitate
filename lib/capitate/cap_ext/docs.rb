module Capitate
  
  module CapExt
    
    module Docs
      
      # Get link to github source, so we can refer to recipe code.
      #
      # ==== Options
      # +recipe+:: Recipe path, probably use __FILE__
      #
      # ==== Examples
      #   # In a lib/recipes/foo/foo.rb
      #   link_to_source(__FILE__) => "http://github.com/gabriel/capitate/tree/master/lib/recipes/foo/foo.rb"
      #
      def link_to_source(recipe_path)
        full_path = File.expand_path(recipe_path)
        project_path = File.expand_path(File.dirname(__FILE__) + "/../../../")
        "http://github.com/gabriel/capitate/tree/master#{full_path.sub(project_path, "")}"
      end
      
    end
    
  end
  
end