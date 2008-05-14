namespace :memcached do 
  
  namespace :centos do
    
    desc <<-DESC
    Install memcached.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:memcached_pid_path, "Path to memcached pid file.", :default => "/var/run/memcached.pid")
    task_arg(:memcached_port, "Memcached port", :default => 11211)
    task_arg(:memcached_memory, "Memcached memory (in MB)")      
    task_arg(:memcached_build_options, <<-EOS)
    Memcached build options
    <pre>
    <code class="ruby">
    set :memcached_build_options, {
      :url => "http://www.danga.com/memcached/dist/memcached-1.2.4.tar.gz",
      :configure_options => "--prefix=/usr/local"
    }
    </code>
    </pre>
    EOS
    task :install do
      # Build
      build.make_install("memcached", memcached_build_options)
      initscript
    end
    
    desc <<-DESC
    Install memcached initscript.    
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:memcached_pid_path, "Path to memcached pid file.", :default => "/var/run/memcached.pid")
    task_arg(:memcached_port, "Memcached port", :default => 11211)
    task_arg(:memcached_memory, "Memcached memory (in MB)")          
    task :initscript do      
      utils.install_template("memcached/memcached.initd.centos.erb", "/etc/init.d/memcached")
      run_via "/sbin/chkconfig --level 345 memcached on"      
    end
    
  end
  
end