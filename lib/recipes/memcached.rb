namespace :memcached do
  
  desc <<-DESC
  Install memcached monit hooks.
  
  memcached_pid_path: Path to memcached pid file. Defaults to /var/run/memcached.pid    
  
    set :memcached_pid_path, "/var/run/memcached.pid"
  
  memcached_port: Memcached port. Defaults to 11211.    
    
    set :memcached_port, 11211
  DESC
  task :install_monit do
    
    # Settings
    fetch_or_default(:memcached_pid_path, "/var/run/memcached.pid")
    fetch_or_default(:memcached_port, 11211)    
    
    put template.load("memcached/memcached.monitrc.erb", binding), "/tmp/memcached.monitrc"    
    sudo "install -o root /tmp/memcached.monitrc /etc/monit/memcached.monitrc"
  end
  
end