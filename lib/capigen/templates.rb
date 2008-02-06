module Capigen::Templates
  
  # Root of templates path
  def template_root
    @template_root ||= File.expand_path(File.dirname(__FILE__) + "/../templates")
  end
  
  # Get full template path
  def full_template_path(template_path)
    File.join(template_root, template_path)
  end
  
  # Load template at (full) path with binding.
  # If options[:project] is true will load template relative to project root.
  def load_template(path, binding, options = {})
    template_path = options[:project] ? "#{root}/#{path}" : full_template_path(path)
    
    unless File.exist?(template_path)
      raise <<-EOS 
      
      Template not found: #{template_path}
      
      For this recipe to work you should have a template available at that path. 
      If you don't want to run this recipe, remove it from the configr.yml or Capfile.
      
      EOS
    end
    
    template = ERB.new(IO.read(template_path))
    template.result(binding)
  end
  
  def load_project_template(path, binding)
    load_template(path, binding, { :project => true })
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
  
end