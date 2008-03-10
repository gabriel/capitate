module Capitate::Plugins::Build
  
  # Configure, make, make install.
  #
  # ==== Options
  # +name+:: Name for app
  # +options+:: Options 
  # - +build_dest+:: Place to build from, ex. /usr/src, defaults to /tmp/name
  # - +url+:: URL to download package from
  # - +configure_options+:: Options for ./configure
  # - +symlink+:: After install, list of source, dest pairs to symlink 
  #    [ { "/usr/local/sphinx-0.9.8-rc1" => "/usr/local/sphinx" }, ... ]
  #    ln -s /usr/local/sphinx-0.9.8-rc1 /usr/local/sphinx
  #
  # - +unpack_dir+:: Directory that is unpacked from tgz (if not matching the file name)
  # - +to_log+:: If specified, will redirect output to this path
  #
  # ==== Examples (in capistrano task)
  #   build.make_install("nginx", { :url => "http://sysoev.ru/nginx/nginx-0.5.35.tar.gz", ... })
  #
  def make_install(name, options)
    install(name, options) do |dir|
      configure_options = options[:configure_options] || ""
      
      # Whether to capture build output
      unless options.has_key?(:to_log)
        to_log = ">> debug.log"
      else
        to_log = ""
        to_log = ">> #{options[:to_log]}" unless options[:to_log].blank?
      end
      
      script.run_all <<-CMDS
        sh -c "cd #{dir} && ./configure #{configure_options} #{to_log}"
        sh -c "cd #{dir} && make #{to_log}"
        sh -c "cd #{dir} && make install #{to_log}"
      CMDS
      
      utils.ln(options[:symlink]) unless options[:symlink].blank?
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
    
    script.unpack(url, build_dest, options) do |dir|
      yield(dir) if block_given?
    end      
  end
        
end

Capistrano.plugin :build, Capitate::Plugins::Build