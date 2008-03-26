namespace :memcached do
  
  namespace :monit do
  
    desc <<-DESC
    Generate and install memcached monitrc.
    "Source":#{link_to_source(__FILE__)}
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