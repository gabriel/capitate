namespace :sphinx do
  
  namespace :centos do
    
    desc <<-DESC
    Install sphinx.\n
    *sphinx_build_options*: Sphinx build options.\n
    *sphinx_prefix*: Sphinx install prefix. _Defaults to "/usr/local/sphinx"_\n
    DESC
    task :install do 
      
      # Settings
      fetch(:sphinx_build_options)
      fetch_or_default(:sphinx_prefix, "/usr/local/sphinx")
      
      # Install dependencies
      yum.install([ "gcc-c++" ])
      
      # Build
      script.make_install("sphinx", sphinx_build_options)
    end
        
    desc <<-DESC
    Setup sphinx for application.\n    
    *sphinx_prefix*: Sphinx install prefix. _Defaults to "/usr/local/sphinx"_\n
    *sphinx_pid_path*: Directory to sphinx pid. _Defaults to "[shared_path]/pids/searchd.pid"_\n
    *sphinx_conf_path*: Path to sphinx.conf. _Defaults to "[shared_path]/config/sphinx.conf"_\n
    DESC
    task :setup do       
      
      # Settings
      fetch_or_default(:sphinx_prefix, "/usr/local/sphinx")
      fetch_or_default(:sphinx_pid_path, "#{shared_path}/pids/searchd.pid")
      fetch_or_default(:sphinx_conf_path, "#{shared_path}/config/sphinx.conf")      

      # Install initscript
      put template.load("sphinx/sphinx_app.initd.centos.erb"), "/tmp/sphinx.initd"
      run_via "install -o root /tmp/sphinx.initd /etc/init.d/sphinx_#{application}"

      # Enable service
      run_via "/sbin/chkconfig --level 345 sphinx_#{application} on"    

      # Create app indexes dir
      run_via "mkdir -p #{shared_path}/var/index"    
    end
  end
  
end