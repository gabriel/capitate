require 'erb'
require 'yaml'

#
# == Configuration helpers
#
# * Loads the configuration 
# * Generates files from templates
#
module Configr::ConfigHelper
    
  # Project root (for rails)
  def root
    RAILS_ROOT
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
        
        This is loaded for the configr plugin. View the README in:
        #{File.expand_path(File.dirname(__FILE__) + "/../doc/README")}
      EOS
    end
    
    root_path
  end
  
  # Root of templates path
  def template_root
    @template_root ||= File.expand_path(File.dirname(__FILE__) + "/../templates")
  end
  
  # Get full template path
  def full_template_path(template_path)
    File.join(template_root, template_path)
  end
  
  # Load template at (full) path with binding
  def load_template(path, binding)
    template_path = full_template_path(path)
    raise "Template not found: #{template_path}" unless File.exist?(template_path)
    
    template = ERB.new(IO.read(template_path))
    template.result(binding)
  end
  
  def load_file(path)
    template_path = full_template_path(path)
    IO.read(template_path)
  end
  
  # Write template at (relative path) with binding to destination path.
  #
  # template_path is relative <tt>"capistrano/deploy.rb.erb"</tt>
  def write_template(template_path, binding, dest_path, verbose = true)        
    if verbose
      relative_dest_path = Pathname.new(File.expand_path(dest_path)).relative_path_from(Pathname.new(File.expand_path(".")))    
      puts "%10s %-40s" % [ "create", relative_dest_path ] 
    end
    
    File.open(dest_path, "w") { |file| file.puts(load_template(template_path, binding)) }
  end
  
  # Remove files from root
  def clean(files, verbose = true)    
    rm_files = files.collect { |f| File.join(root, f) }
    rm_files.each do |rm_file|
      puts "%10s %-40s" % [ "delete", rm_file ] if verbose
      FileUtils.rm_rf(rm_file)
    end
  end

  # Load binding from the config object (generated from the configr yaml)
  def load_binding_from_config(path)
    config = YAML.load_file(path)
    Configr::Config.binding_from_hash(config)
  end
    
end

