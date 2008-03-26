# Task node in the capistrano namespace, task hierarchy.
class Capitate::TaskNode
  
  include Capitate::Plugins::Base
  
  attr_reader :name, :nodes, :tasks, :parent

  # Create task node with name and parent
  # For root not use name = "top"
  #
  # ==== Options
  # +name+:: Node name (namespace name)
  # +parent+:: Parent node
  #
  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @nodes = []
    @tasks = []
  end
  
  # Add "child" node.
  #
  # ==== Options
  # +task_node+:: Node
  #
  def add_node(task_node)
    @nodes << task_node
  end
  
  # Find node with name (namespace).
  #
  # ==== Options
  # +name+:: Name to look for
  #
  def find(name)
    @nodes.each do |node| 
      return node if node.name == name
    end
    nil
  end
  
  # Add task to this node.
  #
  # ==== Options
  # +task+:: Add task associated with this node (namespace).
  #
  def add_task(task)
    @tasks << task
  end
  
  # Get "child" nodes (sorted).
  def sorted_nodes
    nodes.sort_by(&:name)
  end
  
  # Get tasks (sorted).
  def sorted_tasks
    tasks.sort_by(&:fully_qualified_name) # { |t| t.name.to_s }
  end
  
  # Iterate over ALL "child" nodes, depth first.
  # Yields |node, level|.
  #
  # ==== Options
  # +level+:: Current level
  #
  def each_node(level = 0, &block)
    sorted_nodes.each do |node|
      yield(node, level)
      node.each_node(level + 1, &block)
    end
  end
  
  # Get the full name, using delimeter
  #
  # ==== Options
  # +delimeter+:: Delimeter
  #
  # ==== Examples
  #   node.full_name(":") => "mysql:centos"  # On node mysql centos node (top -> mysql -> centos)
  #
  def full_name(delimeter = "-")
    if parent
      parent_name = parent.full_name
      return [ parent_name, name ].compact.join(delimeter)
    end
    
    # Return nil for top node
    name == "top" ? nil : name
  end
  
  # Write textile documentation for node (recursively).
  #
  # Uses task desc attribute for task details.
  #
  # ==== Options
  # +dir+:: Dir to write to
  # +file_name+:: File name to write to, defaults to full name
  # +title+:: Title and h1 for page, defaults to name
  # +options+:: Options
  #
  # ==== Write doc options
  # +include_source+:: If true, include source
  #
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
      unless nodes.empty?
        file.puts "\n\nh2. Namespaces\n\n"
        each_node do |snode, level|
          #li_level = (0..level).collect { "*" }.join
          if snode.tasks.length > 0
            file.puts %{* "#{snode.full_name(":")}":#{snode.full_name}.html (#{snode.tasks.length}) \n}                  
          end
        end        
      end
      
      #
      # Tasks
      # 
      unless tasks.empty?
        file.puts "\n\nh2. Tasks\n\n"
        sorted_tasks.each do |task|
          file.puts %{* "#{task.fully_qualified_name}":##{task.fully_qualified_name} \n}                  
        end        
      end
      
      #
      # Task details
      #
      unless tasks.empty?
        file.puts "\n\nh2. Task documentation\n\n"        
        sorted_tasks.each do |task|
          file.puts %{<div class="recipe">\n\n}
          file.puts "h3(##{task.fully_qualified_name}). #{task.fully_qualified_name}\n\n"
          file.puts "#{unindent(task.desc)}\n\n"
          
          if options[:include_source]
            file_name, source, comments = Capitate::TaskNode.find_source(task.fully_qualified_name)
            unless source.blank?
              file.puts "\n\nh4. Source\n\n<pre><code class='ruby'>#{source}</code></pre>\n\n"
            end
          end
          
          file.puts "</div>\n\n\n"
        end
      end
      
      #
      # Write doc (recursively for "child" namespace)
      #
      sorted_nodes.each do |snode|
        snode.write_doc(dir, nil, nil, options)
      end
      
      # If block then let it do stuff with open file
      if block_given?
        file.puts "\n\n"
        yield(file) 
      end      
    end
  end
  
  # Node to string. 
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
  
  # Weird way of getting at original source
  def self.find_source(full_task_name)
    
    # Load all the recipes into map; I know you think this is cheesy
    @@recipes_text_map ||= begin        
      map = {}
      Dir[File.dirname(__FILE__) + "/../recipes/**/*.rb"].each do |file|
        file_text = ""
        File.open(file) { |f| file_text = f.read }
        map[file] = file_text
      end
      map 
    end
    
    name_parts = full_task_name.split(":")
    pre_namespaces = name_parts.split(":")[0..-3]
    namespace_before = name_parts[-2]
    task_name = full_task_name.split(":").last
    
    # Regex attempt #1: Try to un-greedy load up to next task
    # Need this because don't know how to be un-greedy for task end and greedy for internal ends
    regexs1 = []
    regexs1 += pre_namespaces.collect do |section|
      "namespace\\s+:#{section}\\s+do.*"
    end
    regexs1 << "namespace\\s+:#{namespace_before}\\s+do(.*)"
    regexs1 << "(task :#{task_name}.*?do.*end).*task.*"
    
    
    # Regex attempt #2: 
    regexs2 = []
    regexs2 += pre_namespaces.collect do |section|
      "namespace\\s+:#{section}\\s+do.*"
    end
    regexs2 << "namespace\\s+:#{namespace_before}\\s+do(.*)"
    regexs2 << "(task :#{task_name}.*?do.*end).*"
    (name_parts.length - 1).times do
      regexs2 << ".*end"
    end  
    
    @@recipes_text_map.each do |file, file_text|        
      if file_text =~ /#{regexs1.to_s}/m or file_text =~ /#{regexs2.to_s}/m
        comment_section = $1
        source_section = $2
        return [ file, source_section, comment_section ]
      end
    end
    
    puts "[WARNING] Source not found for: #{full_task_name}"
    
    nil
  end
    
  # Create nodes and and task to node.
  #
  # If task is "mysql:centos:install", the nodes will look like:
  #
  #   (top node) -> (mysql node) -> (centos node; w/ tasks: install)
  #
  # ==== Options
  # +top_node+:: Node to start at
  # +task+:: Task to add
  #    
  def self.populate_with_task(top_node, task)
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
  