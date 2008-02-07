module Capigen::Plugins::Templates
  
  # Root of templates path
  def gem_templates_root
    File.expand_path(File.dirname(__FILE__) + "/../../templates")
  end
  
  # Get full template path
  def gem_template_path(template_path)
    File.join(gem_templates_root, template_path)
  end
  
  # Load template. If extension is erb will be evaluated with binding.
  # 
  # ==== Options
  # +path+:: If starts with '/', absolute path, otherwise relative path to templates dir
  # +binding+:: Binding
  #
  def load(path, override_binding = nil)
    template_paths = [ path, gem_template_path(path) ]
    
    template_paths = template_paths.select { |file| File.exist?(file) }
    
    if template_paths.empty?
      raise <<-EOS 
      
      Template not found: #{template_paths.join("\n\t")}
      
      EOS
    end
    
    # Use first
    template_path = template_paths.first
    
    data = IO.read(template_path)
    
    if File.extname(template_path) == ".erb"    
      template = ERB.new(data)
      data = template.result(override_binding || binding)
    end
    data
  end
  
  # Load template from project
  def project(path, override_binding = nil)
    load(project_root + "/" + path, override_binding || binding)
  end
    
  # Write template at (relative path) with binding to LOCAL destination path.
  #
  # ==== Options
  # +template_path+:: Path to template relative to templates path
  #
  def write(template_path, binding, dest_path, overwrite = false, verbose = true)    
    # This is gnarly!
    relative_dest_path = Pathname.new(File.expand_path(dest_path)).relative_path_from(Pathname.new(File.expand_path(".")))  
    
    if !overwrite && File.exist?(dest_path) 
      puts "%10s %-40s (skipped)" % [ "create", relative_dest_path ] if verbose
      return
    end
    
    puts "%10s %-40s" % [ "create", relative_dest_path ] if verbose
        
    File.open(dest_path, "w") { |file| file.puts(load(template_path, binding)) }
  end
    
end

Capistrano.plugin :template, Capigen::Plugins::Templates