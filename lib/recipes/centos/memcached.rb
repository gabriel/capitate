namespace :centos do 
  
  namespace :memcached do
    
    desc "Install memcached"
    task :install do

      # Settings
      memcached_pid_path = profile.get_or_default(:memcached_pid_path, "/var/run/memcached.pid")
      memcached_memory = profile.get(:memcached_memory)
      memcached_port = profile.get_or_default(:memcached_port, 11211)

      # Build options
      memcached_options = {
        :url => "http://www.danga.com/memcached/dist/memcached-1.2.4.tar.gz",
        :configure_options => "--prefix=/usr/local"
      }

      # Build
      script.make_install(memcached_options, "/tmp/memcached.initd")

      # Install initscript, service
      put template.load("memcached/memcached.initd.centos.erb"), "/tmp/memcached.initd"
      sudo "install -o root /tmp/memcached.initd /etc/init.d/memcached && rm -f /tmp/memcached.initd"
      sudo "/sbin/chkconfig --level 345 memcached on"

    end
    
  end
  
end