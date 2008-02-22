namespace :docs do
  
  desc "Generate documentation for all currently loaded recipes."
  task :recipes do
    top_node = capitate.task_tree
    
    puts "Tree:\n#{}"
    
    dir = "docs/recipes"
    FileUtils.rm_rf(dir)
    FileUtils.mkdir_p(dir)
    
    top_node.write_doc(dir, "index", "Recipes")
    
  end
end

