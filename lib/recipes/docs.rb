namespace :docs do
  
  desc <<-DESC
  Generate documentation for all currently loaded recipes. Assumes textile formatting.
  
  *docs_recipes_dir*: Destination directory. _Defaults to "docs/recipes"_
  
  @set :docs_recipes_dir, "docs/recipes"@
     
  *docs_recipes_clear*: Whether to clear destination before generating.
  
  @set :docs_recipes_clear, true@
    
  DESC
  task :recipes do
    
    # Settings
    fetch_or_default(:docs_recipes_dir, "docs/recipes")
    fetch_or_default(:docs_recipes_clear, true)
    
    # Build task tree
    top_node = capitate.task_tree
        
    FileUtils.rm_rf(docs_recipes_dir) if docs_recipes_clear
    FileUtils.mkdir_p(docs_recipes_dir)
    
    top_node.write_doc(docs_recipes_dir, "index", "Recipes")
    
  end
end

