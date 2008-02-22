class Capitate::TaskNode
  
  include Capitate::Plugins::Base
  
  attr_reader :name, :nodes, :tasks, :parent
    
  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @nodes = []
    @tasks = []
  end
  
  def add_node(task_node)
    @nodes << task_node
  end
  
  def find(name)
    @nodes.each do |node| 
      return node if node.name == name
    end
    nil
  end
  
  def add_task(task)
    @tasks << task
  end
  
  def sorted_nodes
    nodes.sort_by(&:name)
  end
  
  def full_name
    if parent
      parent_name = parent.full_name
      return [ parent_name, name ].compact.join("_")
    end
    
    # Return nil for top node
    name == "top" ? nil : name
  end
  
  # Write doc for current node
  def write_doc(dir)
    
    path = "#{dir}/#{full_name}.txt"
    puts "%10s %-30s" % [ "create", path ]
    
    File.open(path, "w") do |file|
      file.puts "h1. Recipes: #{name}\n\n"      
    
      sub_namespaces = sorted_nodes.collect(&:name)
      file.puts "h2. Namespaces\n"
      sorted_nodes.each do |snode|
        file.puts "#{snode.name}\n"
        
        snode.write_doc(dir)
      end
      
      file.puts "\n\n"
      file.puts "h2. Tasks\n"        
      tasks.each do |task|
        file.puts "h2. #{task.fully_qualified_name}\n\n"
        file.puts "#{unindent(task.desc)}\n\n\n\n"
      end
    end
  end
  
  def to_s(level = 0)
    spaces = "     "
    indent = (0...level).collect { spaces }.join("") 
    
    # Ignore top node (level = -1)
    if level >= 0
      t_indent = "\n#{indent} #{spaces} - "
      task_names = tasks.collect(&:name).sort_by(&:to_s).join(t_indent)
      s = "#{indent} -- #{name}:#{t_indent}#{task_names}\n"
    else
      s = ""
    end
    
    sorted_nodes.each do |node|    
      s += node.to_s(level + 1)
    end
    s
  end
      
  class << self
    
    def populate_with_task(top_node, task)
      node_names = task.namespace.fully_qualified_name.split(":")
      
      node = top_node
      
      node_names.each do |name|
        parent_node = node
        node = parent_node.find(name)
        if !node
          node = self.new(name, parent_node)
          parent_node.add_node(node)
        end
      end
      node.add_task(task)      
    end
  
  end
end
  