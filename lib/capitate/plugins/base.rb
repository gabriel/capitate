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
  
  # Usage for current task.
  #
  # ==== Options
  # +variable+:: Missing variable setting
  #
  # ==== Examples
  #   usage(:gem_list) => "Description from task definition."
  # 
  def usage(variable)
  return <<-EOS
    
    Error: :#{variable} not set.
    
    Usage: 
    
#{indent_doc(current_task.desc)}
    
    EOS
  end
  
  
  def indent_doc(s, amount = 8)
    return nil if s.blank?
    indentation = (0..amount).collect { |n| " " }.join
    s.split("\n").collect { |sp| "#{indentation}#{sp}"}.join("\n")
  end
    
end

Capistrano.plugin :capitate, Capitate::Plugins::Base