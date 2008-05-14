namespace :docs do
  
  desc <<-DESC
  Generate documentation for all currently loaded recipes. Assumes textile formatting.
  
  This recipe generated this documentation.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:docs_recipes_dir, "Destination directory", :default => "docs/recipes")
  task_arg(:docs_recipes_clear, "Whether to clear destination before generating.", :default => true)
  task :recipes do
    
    # Build task tree
    top_node = capitate.task_tree
        
    FileUtils.rm_rf(docs_recipes_dir) if docs_recipes_clear
    FileUtils.mkdir_p(docs_recipes_dir)
    
    top_node.write_doc(docs_recipes_dir, "index", "Recipes", :include_source => true)
    
  end
end

