module Capitate::Plugins::Utils
  
  # Symlink source to dest
  #
  # ==== Options
  # +args+:: Arguments. If argument is hash, then key is symlinked to value.
  #
  # ==== Examples
  #   utils.ln("src/foo" => "dest/foo") # Run: ln -nfs src/foo dest/foo
  #   utils.ln("src/foo" => "dest/foo", "src/bar" => "dest/bar") # Links both
  #
  def ln(*args)    
    args.each do |arg|
      if arg.is_a?(Hash)
        arg.each do |src, dest|
          run_via "ln -nfs #{src} #{dest}"    
        end    
      end
    end
  end
  
  # Load template and install it.
  # Removes temporary files during transfer and ensures desination directory is created before install.
  #
  # See template plugin for where template paths are loaded from.
  #
  # ==== Options
  # +template_path+:: Path to template
  # +destination+:: Remote path to evaluated template
  # +options+:: Options (see Install template options)
  #
  # ==== Install template options
  # +user+:: User to install (-o). Defaults to *root*.
  # +mode+:: Mode to install file (-m)
  #
  # ==== Example
  #   utils.install_template("monit/memcached.monitrc.erb", "/etc/monit/memcached.monitrc", :user => "root", :mode => "600")
  #
  def install_template(template_path, destination, options = {})
    # Truncate extension
    tmp_file_path = template_path.gsub("/", "_").gsub(/.erb$/, "")    
    tmp_path = "/tmp/#{tmp_file_path}"
    
    options[:user] ||= "root"
    
    install_options = []
    install_options << "-o #{options[:user]}"
    install_options << "-m #{options[:mode]}" if options.has_key?(:mode)
    
    put template.load(template_path), tmp_path    
    # TOOD: Ensure directory exists? mkdir -p #{File.dirname(destination)}
    run_via "install #{install_options.join(" ")} #{tmp_path} #{destination} && rm -f #{tmp_path}"
  end
  
  # Grep file for regex. Returns true if found, false otherwise.
  #
  # ==== Options
  # +grep+:: Regular expression
  # +path+:: Path to file
  #
  # ==== Example
  #   utils.egrep("^mail.\\*", "/etc/syslog.conf") => true
  # 
  def egrep(grep, path)
    found = true
    run_via %{egrep '#{grep}' #{path} || echo $?} do |channel, stream, data|    
      if data =~ /^(\d+)/
        if $1.to_i > 0
          logger.trace "Not found"
          found = false 
        end
      end
    end
    found
  end
  
  # Check if file exists.
  #
  # ==== Options
  # +path+:: Path to file
  #
  def exist?(path)
    found = true
    run_via "head -1 #{path} >/dev/null 2>&1 || echo $?" do |channel, stream, data|
      if data =~ /^(\d+)/
        if $1.to_i > 0
          logger.trace "Not found"
          found = false 
        end
      end
    end
    found
  end
  
  # Append data to a file.
  # Optionally check that it exists before adding.
  #
  # ==== Options
  # +path+:: Path to file to append to
  # +data+:: String data to append
  # +check+:: If not nil, will check to see if egrep matches this regex and will not re-append
  # +left_strip+:: If true (default), remove whitespace before lines
  # +should_exist+:: If true (default), raise error if file does not exist
  #
  def append_to(path, data, check = nil, left_strip = true, should_exist = true)
    # If checking and found expression then abort append
    return if check and egrep(check, path)

    # If should exist and doesn't then abort append
    raise "Can't append to file. File should exist: #{path}" if should_exist and !exist?(path)

    data.split("\n").each do |line|
      line = line.gsub(/^\s+/, "") if left_strip
      run_via "echo '#{line}' >> #{path}"
    end
  end
  
end

Capistrano.plugin :utils, Capitate::Plugins::Utils