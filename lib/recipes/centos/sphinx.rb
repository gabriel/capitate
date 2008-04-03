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

      initscript

      # Create app indexes dir
      run "mkdir -p #{shared_path}/var/index"    
    end
    
    
    desc "Setup sphinx initscript"
    task :initscript do      

      fetch_or_default(:sphinx_prefix, "/usr/local/sphinx")
      fetch_or_default(:sphinx_pid_path, "#{shared_path}/pids/searchd.pid")
      fetch_or_default(:sphinx_conf_path, "#{shared_path}/config/sphinx.conf")      
      fetch_or_default(:sphinx_index_root, "#{shared_path}/var/index")      
      
      utils.install_template("sphinx/sphinx_app.initd.centos.erb", "/etc/init.d/sphinx_#{application}")
      run_via "/sbin/chkconfig --level 345 sphinx_#{application} on"
      
    end
    
  end
  
end