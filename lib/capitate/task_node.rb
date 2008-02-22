# TODO: Document this class
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
  
  # Depth first iteration
  def each_node(level = 0, &block)
    sorted_nodes.each do |node|
      yield(node, level)
      node.each_node(level + 1, &block)
    end
  end
  
  def full_name(delimeter = "-")
    if parent
      parent_name = parent.full_name
      return [ parent_name, name ].compact.join(delimeter)
    end
    
    # Return nil for top node
    name == "top" ? nil : name
  end
  
  # Write doc for node (recursively)
  def write_doc(dir, file_name = nil, title = nil, options = {}, &block)
    
    file_name ||= full_name
    title ||= full_name(":")
    
    path = "#{dir}/#{file_name}.txt"
    puts "%10s %-30s" % [ "create", path ]
    
    File.open(path, "w") do |file|
      file.puts "h1. #{title}\n\n"      
      
      #
      # Breadcrumb generate
      #
      bc_full_name = full_name(":")
      links = []
      if bc_full_name
        names = bc_full_name.split(":")
        links << " #{names.pop} " # Pop off current
        
        while(!names.empty?) do          
          links << %{ "#{names.last}":#{names.join("-")}.html }
          names.pop
        end
      end
      # Write breadcrumb
      file.puts %{ "home":../index.html > "recipes":index.html > #{links.reverse.join(" > ")} }
    
      #
      # Namespace
      #
      unless sorted_nodes.empty?
        file.puts "h2. Namespaces\n\n"
        each_node do |snode, level|
          li_level = (0..level).collect { "*" }.join
          file.puts %{#{li_level} "#{snode.full_name(":")}":#{snode.full_name}.html \n}                  
        end        
      end
      
      #
      # Tasks
      #
      unless tasks.empty?
        file.puts "\n\n"
        file.puts "h2. Tasks\n\n"        
        tasks.each do |task|
          file.puts "h3. #{task.fully_qualified_name}\n\n"
          file.puts "#{unindent(task.desc)}\n\n\n\n"
        end
      end
      
      #
      # Write doc (recursively for "child" namespace)
      sorted_nodes.each do |snode|
        snode.write_doc(dir)
      end
      
      # If block then let it do stuff with open file
      if block_given?
        file.puts "\n\n"
        yield(file) 
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
  