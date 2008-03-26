module Capitate::Plugins::Templates
  
  # Load template. If the extension is .erb will be evaluated with binding.
  #
  # You can add to the list of places we search for templates by setting:
  #
  #    set :templates_dirs, [ "path/to/templates1", "/path/to/templates2" ]
  #
  # It looks for the template from:
  # * the <tt>:templates_dirs</tt> setting (if set)
  # * the current directory
  # * the <tt>:project_root</tt> setting (if set)
  # * the gem templates path  
  # 
  # ==== Options
  # +path+:: If starts with '/', absolute path, otherwise relative path to templates dir
  # +override_binding+:: Binding to override, otherwise uses current (task) binding
  #
  # ==== Examples
  #   template.load("memcached/memcached.monitrc.erb") => "This is the text of eval'ed template found at ..."
  #
  #   put template.load("memcached/memcached.monitrc.erb"), "/tmp/memcached.monitrc" # Uploads eval'ed template to remote /tmp/ directory
  #
  def load(path, override_binding = nil)
    template_dirs_found = template_dirs.select { |dir| File.exist?("#{dir}/#{path}") }
    
    # Not found anywhere, throw error
    if template_dirs_found.empty?
      raise "\n\nTemplate not found: #{path}\n\n"
    end
    
    # Use first
    template_path = template_dirs_found.first + "/#{path}"
    
    template_data = IO.read(template_path)
    
    if File.extname(template_path) == ".erb"    
      template = ERB.new(template_data)
      template_data = template.result(override_binding || binding)
    end
    template_data
  end
    
  # Write template at (relative path) with binding to LOCAL destination path.
  #
  # ==== Options
  # +template_path+:: Path to template relative to templates path
  # +dest_path+:: Local destination path to write to
  # +overwrite_binding+:: Binding  
  # +overwrite+:: Force overwrite
  # +verbose+:: Verbose output
  #
  # ==== Examples
  #   template.write("config/templates/sphinx.conf.erb", "config/sphinx.conf")
  #  
  def write(template_path, dest_path, override_binding = nil, overwrite = false, verbose = true)    
    # This is gnarly!
    relative_dest_path = Pathname.new(File.expand_path(dest_path)).relative_path_from(Pathname.new(File.expand_path(".")))  
    
    if !overwrite && File.exist?(dest_path) 
      puts "%10s %-40s (skipped)" % [ "create", relative_dest_path ] if verbose
      return
    end
    
    puts "%10s %-40s" % [ "create", relative_dest_path ] if verbose
    template_data = load(template_path, override_binding)
    File.open(dest_path, "w") { |file| file.puts(load(template_path, override_binding)) }
  end
    
    
protected

  # Load all possible places for templates.
  #
  # Returns:
  # * the <tt>:templates_dirs</tt> setting (if set)
  # * the current directory
  # * the <tt>:project_root</tt> setting (if set)
  # * the gem templates path
  #
  def template_dirs
    @template_dirs ||= begin
      template_dirs = []      
      template_dirs += fetch(:templates_dirs) if exists?(:templates_dirs)      
      template_dirs << "."
      template_dirs << project_root if exists?(:project_root)
      template_dirs << gem_templates_root
      template_dirs
    end
  end

  # Get the absolute base templates path.
  def gem_templates_root
    File.expand_path(File.dirname(__FILE__) + "/../../templates")
  end
  
  # Get full template path from relative path.
  #
  # ==== Options 
  # +template_path+:: Relative path
  #
  # ==== Examples
  #    gem_template_path("monit/monit.cnf") => /usr/lib/..../capitate/lib/templates/monit/monit.cnf
  #
  def gem_template_path(template_path)
    File.join(gem_templates_root, template_path)
  end
  
end

Capistrano.plugin :template, Capitate::Plugins::Templates