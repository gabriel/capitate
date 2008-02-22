namespace :capistrano do
  
  desc "Generate documentation for all currently loaded recipes"
  task :recipe_docs do
    top_node = capitate.task_tree
    
    puts "Tree:\n#{top_node.to_s(-1)}"
    
    dir = "docs/recipes"
    
    top_node.sorted_nodes.each do |node|
      node.write_doc(dir)
    end
  end
end

