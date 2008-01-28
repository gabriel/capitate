require 'erb'
require 'yaml'

# == Configuration helpers
#
# * Loads the configuration 
# * Generates files from templates
#
module Configr::ConfigHelper
    
  # Project root (for rails)
  def root
    if respond_to?(:fetch)
      return fetch(:project_root)
    end
    
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
  def write_template(template_path, binding, dest_path, overwrite = false, verbose = true)    
    # This is gnarly!
    relative_dest_path = Pathname.new(File.expand_path(dest_path)).relative_path_from(Pathname.new(File.expand_path(".")))  
    
    if !overwrite && File.exist?(dest_path) 
      puts "%10s %-40s (skipped)" % [ "create", relative_dest_path ] if verbose
      return
    end
    
    puts "%10s %-40s" % [ "create", relative_dest_path ] if verbose
        
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
  
  # The default path to the configr yaml.
  def configr_yml_path
    @configr_yml_path ||= "#{root}/config/configr.yml"
  end
  
  def load_config_yaml
    YAML.load_file(configr_yml_path)
  end
  
  def config
    @config ||= Configr::Config.new(load_config_yaml)
  end
  
  # Check for config file and a good version
  def check_config
    if File.exist?(configr_yml_path)
      hash = load_config_yaml
      return Configr::Config.check_version(hash)
    end
    return false
  end
  
  # Load binding from the config object (generated from the configr yaml)
  def load_binding_from_config(path)
    config = YAML.load_file(path)
    Configr::Config.binding_from_hash(config)
  end
  
  def capfile_callbacks
    recipes = Configr::Config.new(YAML.load_file(configr_yml_path)).recipes
    tasks = [ "install", "setup", "update_code" ]
    load_callbacks(recipes, tasks)
  end
  
  # Load callbacks from recipes list and tasks list
  def load_callbacks(recipes, tasks)
    callbacks = []

    tasks.each do |task|
      recipes[task].each do |call_when, recipes|
        recipes.each do |recipe|
          callbacks << { :when => call_when.to_sym, :deploy_task => "deploy:#{task}",  :recipe_callback => "#{recipe}:#{task}" }
        end
      end
    end

    callbacks
  end
  
  def install_callbacks
    recipes_path = File.dirname(__FILE__) + "/../../config/image_recipes.yml"
    recipes = YAML.load_file(recipes_path)
    load_callbacks(recipes, [ "install" ])
  end
    
end

