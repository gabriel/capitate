module Capitate::Plugins::Script
  
  # Run (sh) script. If script has .erb extension it will evaluate it.
  #
  # ==== Options
  # +script+:: Name of sh file (relative to templates dir)
  # +override_binding++:: Binding to override, otherwise defaults to current (task) context
  #
  # ==== Examples
  #   script.sh("ruby/openssl_fix.sh")
  #
  def sh(script, override_binding = nil)
        
    if File.extname(script) == ".erb"
      name = script[0...script.length-4]
      dest = "/tmp/cap/#{name}"
      run_via "mkdir -p #{File.dirname(dest)}"
      put template.load(script, override_binding || binding), dest
    else
      name = script
      dest = "/tmp/cap/#{name}"
      run_via "mkdir -p #{File.dirname(dest)}"
      put template.load(script), dest
    end
    
    # If want verbose, -v
    run_all <<-CMDS
      sh -v #{dest}
      rm -rf #{File.dirname(dest)}
    CMDS
  end
  
  # Download and unpack URL.
  # Yields path to unpacked source.
  #
  # ==== Options
  # +url+:: URL to download
  # +dest+:: Destination directory
  # +options+:: Options (see Unpack options)
  #
  # ==== Unpack options
  # +clean+:: If true will remove the unpacked directory. _Defaults to true_
  # +unpack_dir+:: Directory that is unpacked from tgz (if not matching the file name)
  #
  # ==== Examples
  #   script.unpack("http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz", "/tmp/rubygems") do
  #     sudo "ruby setup.rb"
  #   end
  #
  def unpack(url, dest, options, &block)        
    file = url.split("/").last
    
    # TODO: Support other types
    if file !~ /\.tar\.gz\Z|\.tgz\Z/
      raise "Can't unpack this file: #{file}; only support tar.gz and tgz formats"
    end
    
    options[:clean] = true if options[:clean].nil?
    unpack_dir = options[:unpack_dir]
    clean = options[:clean]
    
    unpack_dir ||= file.gsub(/\.tar\.gz|\.tgz/, "")
    
    http_get_method = fetch(:http_get_method, "wget -nv")
        
    run_all <<-CMDS
      sh -c "mkdir -p #{dest} && cd #{dest} && #{http_get_method} #{url}"
      sh -c "cd #{dest} && tar zxf #{file}"
    CMDS
    
    if block_given?
      yield("#{dest}/#{unpack_dir}")
      run_via "rm -f #{dest}/#{file}"
      run_via "rm -rf #{dest}" if clean
    end
  end
  
  # Run all commands (separated by newlines).
  # 
  # Uses run_via to execute, so will use <tt>run</tt> or <tt>sudo</tt>
  # depending on the current <tt>:run_method</tt>
  #
  # ==== Options
  # +cmds+:: Commands (separated by newlines)
  # +options+:: See Capistrano invoke_command options
  #
  def run_all(cmds, options = {}, &block)    
    cmds.split("\n").each do |cmd|
      cmd = cmd.gsub(/^\s+/, "")        
      run_via(cmd, options, &block)
    end    
  end  
  
end

Capistrano.plugin :script, Capitate::Plugins::Script