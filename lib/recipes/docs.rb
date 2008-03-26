namespace :docs do
  
  desc <<-DESC
  Generate documentation for all currently loaded recipes. Assumes textile formatting.
  
  This recipe generated this documentation.
  
  <dl>
  <dt>docs_recipes_dir</dd>
  <dd>Destination directory</dd>
  <dd class="default">Defaults to @docs/recipes@</dd>  
  <dd>@set :docs_recipes_dir, "docs/recipes"@</dd>   
    
  <dt>docs_recipes_clear</dt>
  <dd>Whether to clear destination before generating.</dd>  
  <dd>@set :docs_recipes_clear, true@</dd>
  </dl>
  DESC
  task :recipes do
    
    # Settings
    fetch_or_default(:docs_recipes_dir, "docs/recipes")
    fetch_or_default(:docs_recipes_clear, true)
    
    # Build task tree
    top_node = capitate.task_tree
        
    FileUtils.rm_rf(docs_recipes_dir) if docs_recipes_clear
    FileUtils.mkdir_p(docs_recipes_dir)
    
    top_node.write_doc(docs_recipes_dir, "index", "Recipes", :include_source => true)
    
  end
end

