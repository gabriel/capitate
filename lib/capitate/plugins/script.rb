module Capitate::Plugins::Script
  
  # Configure, make, make install.
  #
  # ==== Options
  # +name+:: Name for app
  # +options+:: Options 
  # - +build_dest+:: Place to build from, ex. /usr/src, defaults to /tmp/name
  # - +url+:: URL to download package from
  # - +configure_options+:: Options for ./configure
  # - +unpack_dir+:: Directory that is unpacked from tgz (if not matching the file name)
  #
  # ==== Examples (in capistrano task)
  #   script.make_install("nginx", { :url => "http://sysoev.ru/nginx/nginx-0.5.35.tar.gz", ... })
  #
  def make_install(name, options)
    install(name, options) do |dir|
      configure_options = options[:configure_options] || ""
      sudo "echo 'Configuring #{name}...' && cd #{dir} && ./configure #{configure_options} > configure.log"
      sudo "echo 'Compiling #{name}...' && cd #{dir} && make > make.log"
      sudo "echo 'Installing #{name}...' && cd #{dir} && make install > make_install.log"        
    end
  end
  
  # Download, unpack and yield (unpacked source director).
  # 
  # ==== Options
  # +name+:: Name for app
  # +options+:: Options
  # - +build_dest+:: Place to build from, ex. /usr/src, defaults to /tmp/name
  # - +url+:: URL to download package from
  # 
  # ==== Examples (in capistrano task)
  #   script.make("rubygems", { :url => :url => "http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz" }) do |dir|
  #     sudo "echo 'Running setup...' && cd #{dir} && ruby #{dir}/setup.rb"
  #   end
  #
  def install(name, options, &block)
    build_dest = options[:build_dest]
    build_dest ||= "/tmp/#{name}"
    url = options[:url]    
    dependencies = options[:dependencies]
    
    package.install(dependencies) if dependencies
    
    unpack(url, build_dest, options[:clean], options[:unpack_dir]) do |dir|
      yield(dir) if block_given?
    end      
  end
    
  
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
      dest = "/tmp/#{name}"
      run "mkdir -p #{File.dirname(dest)}"
      put template.load(script, override_binding || binding), dest
    else
      name = script
      dest = "/tmp/#{name}"
      run "mkdir -p #{File.dirname(dest)}"
      put template.load(script), dest
    end
    
    # If want verbose, -v
    sudo "sh -v #{dest}"
    
    # Cleanup
    sudo "rm -rf #{File.dirname(dest)}"    
  end
  
  # Download and unpack URL.
  # Yields path to unpacked source.
  #
  # ==== Options
  # +url+:: URL to download
  # +dest+:: Destination directory
  # +clean+:: If true will remove the unpacked directory
  # +unpack_dir+:: Directory that is unpacked from tgz (if not matching the file name)
  #
  # ==== Examples
  #   script.unpack("http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz", "/tmp/rubygems") do
  #     sudo "ruby setup.rb"
  #   end
  #
  def unpack(url, dest, clean = true, unpack_dir = nil, &block)        
    file = url.split("/").last
    
    # TODO: Support other types
    if file !~ /\.tar\.gz\Z|\.tgz\Z/
      raise "Can't unpack this file: #{file}; only support tar.gz and tgz formats"
    end
    
    unpack_dir ||= file.gsub(/\.tar\.gz|\.tgz/, "")
    
    sudo "echo 'Getting #{url}...' && mkdir -p #{dest} && cd #{dest} && wget -nv #{url}"
    sudo "echo 'Unpacking...' && cd #{dest} && tar zxf #{file}"
    
    if block_given?
      yield("#{dest}/#{unpack_dir}")
      sudo "rm -f #{dest}/#{file}"
      sudo "rm -rf #{dest}" if clean
    end
  end
  
end

Capistrano.plugin :script, Capitate::Plugins::Script