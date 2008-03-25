namespace :memcached do
  
  desc "Create memcached yaml in shared path."
  task :setup do    

    # Settings
    fetch(:memcached_namespace)
    fetch_or_default(:memcached_ttl, 3600)
    fetch_or_default(:memcached_readonly, false)
    fetch_or_default(:memcached_urlencode, false)
    fetch_or_default(:memcached_c_threshold, 10000)
    fetch_or_default(:memcached_compression, true)
    fetch_or_default(:memcached_debug, false)
    fetch_or_default(:memcached_servers, [ "localhost:11211" ])
    fetch_or_default(:memcached_yml_template, "memcached/memcached.yml.erb")    

    utils.install_template(memcached_yml_template, "#{shared_path}/config/memcached.yml")
  end

  desc "Symlink memcached configuration after deploy."
  task :update_code, :roles => :app do 
    run "ln -nfs #{shared_path}/config/memcached.yml #{release_path}/config/memcached.yml" 
  end
  
  namespace :monit do
  
    desc <<-DESC
    Generate and install memcached monitrc.
    
    *memcached_pid_path*: Path to memcached pid file. _Defaults to /var/run/memcached.pid_\n  
    @set :memcached_pid_path, "/var/run/memcached.pid"@\n  
    *memcached_port*: Memcached port. _Defaults to 11211_\n  
    @set :memcached_port, 11211@\n     
    *monit_conf_dir*: Destination for monitrc. _Defaults to "/etc/monit"_\n  
    @set :monit_conf_dir, "/etc/monit"@\n     
    DESC
    task :install do
    
      # Settings
      fetch_or_default(:memcached_pid_path, "/var/run/memcached.pid")
      fetch_or_default(:memcached_port, 11211)    
      fetch_or_default(:monit_conf_dir, "/etc/monit")
    
      put template.load("memcached/memcached.monitrc.erb"), "/tmp/memcached.monitrc"    
      run_via "install -o root /tmp/memcached.monitrc #{monit_conf_dir}/memcached.monitrc"
    end
    
  end
  
end