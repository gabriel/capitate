namespace :sphinx do
  
  namespace :centos do
    
    desc <<-DESC
    Install sphinx.\n
    
    <dl>
    <dt>sphinx_build_options</dt>
    <dd>Sphinx build options.</dd>
    <dd>
    <pre>
    <code class="ruby">
    set :sphinx_build_options, {
      :url => "http://www.sphinxsearch.com/downloads/sphinx-0.9.7.tar.gz",
      :configure_options => "--with-mysql-includes=/usr/include/mysql --with-mysql-libs=/usr/lib/mysql 
        --prefix=\#{sphinx_prefix}"
    }
    </code>    
    </pre>
    </dd>
    
    <dt>sphinx_prefix</dt>
    <dd>Sphinx install prefix</dd>
    <dd class="default">Defaults to @/usr/local/sphinx@</dd>
    </dl>
    DESC
    task :install do 
      
      # Settings
      fetch(:sphinx_build_options)
      fetch_or_default(:sphinx_prefix, "/usr/local/sphinx")
      
      # Install dependencies
      yum.install([ "gcc-c++" ])
      
      # Build
      build.make_install("sphinx", sphinx_build_options)
    end
        
    desc <<-DESC
    Setup sphinx for application.
  
    <dl>
    <dt>sphinx_prefix</dt><dd>Sphinx install prefix</dd><dd class="default">Defaults to @/usr/local/sphinx@</dd>
    <dt>sphinx_pid_path</dt><dd>Directory to sphinx pid</dd><dd class="default">Defaults to @\#{shared_path}/pids/searchd.pid@</dd>
    <dt>sphinx_conf_path</dt><dd>Path to sphinx.conf</dd><dd class="default">Defaults to @\#{shared_path}/config/sphinx.conf@</dd>
    <dt>sphinx_index_path</dt><dd>Path to sphinx indexes</dd><dd class="default">Defaults to @\#{shared_path}/var/index@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :setup do       
      
      # Settings
      fetch_or_default(:sphinx_prefix, "/usr/local/sphinx")
      fetch_or_default(:sphinx_pid_path, "#{shared_path}/pids/searchd.pid")
      fetch_or_default(:sphinx_conf_path, "#{shared_path}/config/sphinx.conf")      
      fetch_or_default(:sphinx_index_root, "#{shared_path}/var/index")      

      # Install initscript
      put template.load("sphinx/sphinx_app.initd.centos.erb"), "/tmp/sphinx.initd"
      run_via "install -o root /tmp/sphinx.initd /etc/init.d/sphinx_#{application}"

      # Enable service
      run_via "/sbin/chkconfig --level 345 sphinx_#{application} on"    

      # Create app indexes dir
      run "mkdir -p #{shared_path}/var/index"    
    end
    
    
    desc <<-DESC
    Install sphinx firewall rule.
    
    This doesn't work yet (doesn't insert in right place).
    
    <dl>
    <dt>sphinx_portdt>
    <dd>Sphinx port</dd>
    <dd class="default">Defaults to @3312@</dd>    
    <dd>@set :sphinx_port, 3312@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :iptables do
      # Settings
      fetch_or_default(:sphinx_port, 3312)      
      run_via "iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport #{sphinx_port} -j ACCEPT"
      run_via "/sbin/service iptables save"
    end
  end
  
end