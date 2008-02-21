namespace :centos do 
  
  namespace :memcached do
    
    desc "Install memcached"
    task :install do

      # Settings
      fetch_or_default(:memcached_pid_path, "/var/run/memcached.pid")
      fetch_or_default(:memcached_port, 11211)
      fetch(:memcached_memory)      

      # Build options
      memcached_options = {
        :url => "http://www.danga.com/memcached/dist/memcached-1.2.4.tar.gz",
        :configure_options => "--prefix=/usr/local"
      }

      # Build
      script.make_install("memcached", memcached_options)

      # Install initscript, service
      put template.load("memcached/memcached.initd.centos.erb"), "/tmp/memcached.initd"
      sudo "install -o root /tmp/memcached.initd /etc/init.d/memcached && rm -f /tmp/memcached.initd"
      sudo "/sbin/chkconfig --level 345 memcached on"

    end
    
  end
  
end