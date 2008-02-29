namespace :memcached do
  
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