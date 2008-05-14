namespace :sphinx do
  
  namespace :centos do
    
    desc <<-DESC
    Install sphinx.\n
    
    DESC
    task_arg(:sphinx_build_options, <<-EOS)
    Sphinx build options.
    <pre>
    <code class="ruby">
    set :sphinx_build_options, {
      :url => "http://www.sphinxsearch.com/downloads/sphinx-0.9.7.tar.gz",
      :configure_options => "--with-mysql-includes=/usr/include/mysql --with-mysql-libs=/usr/lib/mysql 
        --prefix=\#{sphinx_prefix}"
    }
    </code>    
    </pre>
    EOS
    task_arg(:sphinx_prefix, "Sphinx install prefix", :default => "/usr/local/sphinx")    
    task :install do 
      # Install dependencies
      yum.install([ "gcc-c++" ])
      
      # Build
      build.make_install("sphinx", sphinx_build_options)
    end
        
    desc <<-DESC
    Setup sphinx for application.
  
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:sphinx_prefix, "Sphinx install prefix", :default => "/usr/local/sphinx")
    task_arg(:sphinx_pid_path, "Directory to sphinx pid", :default => Proc.new{"#{shared_path}/pids/searchd.pid"}, :default_desc => "\#{shared_path}/pids/searchd.pid")
    task_arg(:sphinx_conf_path, "Path to sphinx.conf", :default => Proc.new{"#{shared_path}/config/sphinx.conf"}, :default_desc => "\#{shared_path}/config/sphinx.conf")      
    task_arg(:sphinx_index_root, "Path to sphinx indexes", :default => Proc.new{"#{shared_path}/var/index"}, :default_desc => "\#{shared_path}/var/index")
    task :setup do       
      initscript
      # Create app indexes dir
      run "mkdir -p #{shared_path}/var/index"    
    end
    
    
    desc "Setup sphinx initscript"
    task_arg(:sphinx_prefix, "Sphinx install prefix", :default => "/usr/local/sphinx")
    task_arg(:sphinx_pid_path, "Directory to sphinx pid", :default => Proc.new{"#{shared_path}/pids/searchd.pid"}, :default_desc => "\#{shared_path}/pids/searchd.pid")
    task_arg(:sphinx_conf_path, "Path to sphinx.conf", :default => Proc.new{"#{shared_path}/config/sphinx.conf"}, :default_desc => "\#{shared_path}/config/sphinx.conf")      
    task_arg(:sphinx_index_root, "Path to sphinx indexes", :default => Proc.new{"#{shared_path}/var/index"}, :default_desc => "\#{shared_path}/var/index")    
    task :initscript do      
      utils.install_template("sphinx/sphinx_app.initd.centos.erb", "/etc/init.d/sphinx_#{application}")
      run_via "/sbin/chkconfig --level 345 sphinx_#{application} on"
      
    end
    
  end
  
end