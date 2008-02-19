require 'erb'
require 'yaml'

# Capitate base capistrano plugin
module Capitate::Plugins::Base
  
  # Project root
  def root
    if respond_to?(:fetch)
      return fetch(:project_root)
    else
      RAILS_ROOT
    end
  end
    
  # Path relative to project root
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
  
  # Documentation (yaml) for current task (namespace).
  # 
  # ==== Examples
  #   capitate.current_task_docs => { "task_name" => { "variable" => "The usage docs" } }
  #
  def current_task_doc
    path = File.dirname(__FILE__) + "/../../doc/" + current_task.namespace.fully_qualified_name.to_s.gsub(":", "/") + ".yml"
    puts "Current task doc: #{path}"
    return YAML.load_file(path) if File.exist?(path)
    nil
  end
  
  # Usage for variable from current task documentation.
  #
  # ==== Options
  # +var+:: Variable
  # 
  # ==== Examples
  #   usage(:gem_list) => "The usage for gem_list variable from the doc/the_namespace.yml file."
  # 
  def usage(var)
    task_doc = current_task_doc
    task_name = current_task.name.to_s
    var_name = var.to_s
    if task_doc and task_doc.has_key?(task_name)    
      var_usage = task_doc[task_name][var_name] 
      return <<-EOS
      
      Please set :#{var_name} variable in your Capfile, deploy.rb or profile.
      
      Usage: 
      
#{indent_doc(var_usage)}
      
      EOS
    end
  end
  
  
  def indent_doc(s, amount = 8)
    indentation = (0..amount).collect { |n| " " }.join
    s.split("\n").collect { |sp| "#{indentation}#{sp}"}.join("\n")
  end
    
end

Capistrano.plugin :capitate, Capitate::Plugins::Base