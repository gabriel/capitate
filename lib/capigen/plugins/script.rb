module Capigen::Plugins::Script
  
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
    install(name, options) do 
      configure_options = options[:configure_options] || ""
      sudo "echo 'Configuring #{name}...' && ./configure #{configure_options} > configure.log"
      sudo "echo 'Compiling #{name}...' && make > make.log"
      sudo "echo 'Installing #{name}...' && make install > make_install.log"        
    end
  end
  
  # Download, unpack and yield.
  # 
  # ==== Options
  # +name+:: Name for app
  # +options+:: Options
  # - +build_dest+:: Place to build from, ex. /usr/src, defaults to /tmp/name
  # - +url+:: URL to download package from
  # 
  # ==== Examples (in capistrano task)
  #   script.make("rubygems", { :url => :url => "http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz" }) do 
  #     sudo "ruby setup.rb"
  #   end
  #
  def install(name, options, &block)
    build_dest = options[:build_dest]
    build_dest ||= "/tmp/#{name}"
    url = options[:url]    
    dependencies = options[:dependencies]
    
    package.install(dependencies) if dependencies
    
    unpack(url, build_dest, options[:clean], options[:unpack_dir]) do 
      yield if block_given?
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
    sudo "sh #{dest}"
    
    # Cleanup
    sudo "rm -rf #{File.dirname(dest)}"    
  end
  
  # Download and unpack URL.
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
    unpack_dir ||= file.gsub(/\.tar\.gz|tgz/, "")
    
    sudo "mkdir -p #{dest} && cd #{dest} && wget -nv #{url}"
    sudo "tar xzf #{file} && cd #{unpack_dir}"
    
    if block_given?
      yield 
      sudo "rm -f #{dest}/#{file}"
      sudo "rm -rf #{unpack_dir}" if clean
    end
  end
  
end

Capistrano.plugin :script, Capigen::Plugins::Script