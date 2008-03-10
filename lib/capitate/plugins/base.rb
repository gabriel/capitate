require 'erb'
require 'yaml'

# Capitate base capistrano plugin
module Capitate::Plugins::Base
  
  # Project root. Fetch from :project_root, or fall back to RAILS_ROOT.
  #
  def root
    if respond_to?(:fetch)
      return fetch(:project_root)
    else
      RAILS_ROOT
    end
  end
    
  # Path relative to project root.
  # Project root is set via, set :project_root, "path/to/project" in Capfile.
  #
  # ==== Options
  # +path+:: Relative path
  # +check_exist+:: Whether to check its existence and throw error if not found
  #
  # ==== Examples
  #   relative_to_root("config/foo.yml") => "path/to/project/config/foo.yml"
  #
  def relative_to_root(path = nil, check_exist = false)
    if path
      root_path = File.join(root, path)
    else
      root_path = root
    end
    
    # Check for file existance
    if check_exist and !File.exist?(root_path)
      raise <<-EOS
        
        File not found: #{File.expand_path(root_path)}
        
        This is loaded for the capitate plugin. View the README in:
        #{File.expand_path(File.dirname(__FILE__) + "/../doc/README")}
      EOS
    end
    
    root_path
  end    
  
  # Usage for current task.
  #
  # ==== Options
  # +variable+:: Missing variable setting
  #
  # ==== Examples
  #   usage(:gem_list) => "Description from task definition."
  # 
  def usage(variable = nil)
    message = ""
    
    if variable
      message += <<-EOS
    
      Error: :#{variable} not set.    
      EOS
    end
    
    message += <<-EOS
    
    Usage: 
    
#{indent_doc(current_task.desc)}
    
    EOS
  end
  
  # Indent string block.
  #
  # ==== Options
  # +s+:: String block
  # +amount+:: Amount to indent
  #
  def indent_doc(s, amount = 4)
    return nil if s.blank?
    indentation = (0..amount).collect { |n| " " }.join
    s.split("\n").collect { |sp| "#{indentation}#{sp}"}.join("\n")
  end
  
  # Unindent, lifted from capistrano bin/capify
  def unindent(string)
    return "" if string.blank?
    if string =~ /\A(\s*)/
      amount = $1.length
      return string.strip.gsub(/^#{$1}/, "")
    end
    string
  end  
  
  # Load all tasks
  def load_all_tasks
    tasks = []
    top.namespaces.each do |namespace|
      load_tasks(namespace, tasks)
    end
    tasks
  end
  
  # Task tree
  def task_tree
    top_node = Capitate::TaskNode.new("top")
    
    load_all_tasks.each do |task|
      Capitate::TaskNode.populate_with_task(top_node, task)
    end
    top_node
  end

protected
  
  def load_tasks(namespace, tasks = [])    
    recipe = namespace.last
    
    recipe.namespaces.each do |nested_namespace|
      load_tasks(nested_namespace, tasks)
    end
    
    recipe.task_list.each do |task|
      tasks << task
    end
  end
    
end

Capistrano.plugin :capitate, Capitate::Plugins::Base