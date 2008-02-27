namespace :memcached do 
  
  namespace :centos do
    
    desc <<-DESC
    Install memcached.
    
    *memcached_build_options*: Memcached build options.\n
    <pre>
    set :memcached_build_options, {
      :url => "http://www.danga.com/memcached/dist/memcached-1.2.4.tar.gz",
      :configure_options => "--prefix=/usr/local"
    }
    </pre>\n
    *memcached_memory*: Memcached memory (in MB).\n    
    @set :memcached_memory, 64@\n
    *memcached_pid_path*: Path to memcached pid file. Defaults to /var/run/memcached.pid\n    
    @set :memcached_pid_path, "/var/run/memcached.pid"@\n
    *memcached_port*: Memcached port. Defaults to 11211.\n    
    @set :memcached_port, 11211@\n      
    DESC
    task :install do

      # Settings
      fetch_or_default(:memcached_pid_path, "/var/run/memcached.pid")
      fetch_or_default(:memcached_port, 11211)
      fetch(:memcached_memory)      
      fetch(:memcached_build_options)

      # Build
      script.make_install("memcached", memcached_build_options)

      # Install initscript, service
      put template.load("memcached/memcached.initd.centos.erb"), "/tmp/memcached.initd"
      run_via "install -o root /tmp/memcached.initd /etc/init.d/memcached && rm -f /tmp/memcached.initd"
      run_via "/sbin/chkconfig --level 345 memcached on"

    end
    
  end
  
end