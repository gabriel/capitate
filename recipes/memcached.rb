namespace :memcached do
  
  after "memcached:install", "memcached:install_init"
  after "memcached:install", "memcached:install_monit"
  
  set :memcached_pid_path, "/var/run/memcached.pid"
  set :memcached_port, 11211
  
  desc "Install memcached"
  task :install do
    script_install("memcached/install.sh")   
  end
  
  desc "Install memcached init"
  task :install_init do
    put load_template("memcached/memcached.initd.centos.erb", binding), "/tmp/memcached.initd"

    sudo "install -o root /tmp/memcached.initd /etc/init.d/memcached && rm -f /tmp/memcached.initd"
    
    # Use monit to manage services
    #sudo "/sbin/chkconfig --level 345 memcached on"            
  end
  
  task :install_monit do
    put load_template("memcached/memcached.monitrc.erb", binding), "/tmp/memcached.monitrc"
    
    sudo "install -o root /tmp/memcached.monitrc /etc/monit/memcached.monitrc && rm -f /tmp/memcached.monitrc"
  end
  
end