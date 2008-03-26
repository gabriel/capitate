namespace :memcached do 
  
  namespace :centos do
    
    desc <<-DESC
    Install memcached.
    
    <dl>
    <dt>memcached_build_options</dt>
    <dd>Memcached build options.</dd>
    <dd>
    <pre>
    <code class="ruby">
    set :memcached_build_options, {
      :url => "http://www.danga.com/memcached/dist/memcached-1.2.4.tar.gz",
      :configure_options => "--prefix=/usr/local"
    }
    </code>
    </pre>
    </dd>
    
    
    <dt>memcached_memory</dt>
    <dd>Memcached memory (in MB).</dd>
    <dd>@set :memcached_memory, 64@</dd>
    
    <dt>memcached_pid_path*</dt>
    <dd>Path to memcached pid file.</dd>
    <dd class="default">Defaults to @/var/run/memcached.pid@</dd>
    <dd>@set :memcached_pid_path, "/var/run/memcached.pid"@</dd>
    
    <dt>memcached_port</dt>
    <dd>Memcached port<dd>
    <dd class="default">Defaults to 11211.</dd>
    <dd>@set :memcached_port, 11211@</dd>
    
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :install do

      # Settings
      fetch_or_default(:memcached_pid_path, "/var/run/memcached.pid")
      fetch_or_default(:memcached_port, 11211)
      fetch(:memcached_memory)      
      fetch(:memcached_build_options)

      # Build
      build.make_install("memcached", memcached_build_options)

      # Install initscript, service
      put template.load("memcached/memcached.initd.centos.erb"), "/tmp/memcached.initd"
      run_via "install -o root /tmp/memcached.initd /etc/init.d/memcached && rm -f /tmp/memcached.initd"
      run_via "/sbin/chkconfig --level 345 memcached on"

    end
    
  end
  
end