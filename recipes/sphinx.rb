# Sphinx recipes
namespace :sphinx do
  
  set :sphinx_prefix, "/usr/local/sphinx"
  
  desc "Install sphinx"
  task :install do 
    package_install([ "gcc-c++" ])
    script_install("sphinx/install.sh.erb")
  end
  
  desc "Setup sphinx for application"
  task :setup do 
    
    sphinx_prefix = fetch(:sphinx_prefix)
    application = config.application
    sphinx_bin_path = "#{sphinx_prefix}/bin"
    sphinx_conf_path = "#{shared_path}/config/sphinx.conf"
    sphinx_pid_path = "#{shared_path}/pids/sphinx_#{application}.pid"
    
    put load_template("sphinx/sphinx_app.initd.erb", binding), "/tmp/sphinx.initd"

    sudo "install -o root /tmp/sphinx.initd /etc/init.d/sphinx_#{application}"
    sudo "/sbin/chkconfig --level 345 sphinx_#{application} on"    
    
    run "mkdir -p #{shared_path}/var/index"    
  end
  
  desc "Update sphinx for application" 
  task :update_code do
    
    rails_root = current_path
    index_root = "#{shared_path}/var/index";
    log_root = "#{shared_path}/log"
    pid_root = "#{shared_path}/pids"
    sphinx_host = config.sphinx_host
    sphinx_port = config.sphinx_port
    db_name = config.db_name
    db_user = config.db_user
    db_pass = config.db_pass
    db_host = config.db_host
    db_port = config.db_port
    
    put load_project_template("config/templates/sphinx.conf.erb", binding), "#{shared_path}/config/sphinx.conf"
    
    # Dont symlink in since we dont want to use sphinx rake tasks in deployed environment
    #run "ln -nfs #{shared_path}/config/sphinx.conf #{release_path}/config/sphinx.conf"
  end
  
  desc "Rotate index"
  task :rotate_all do
    sphinx_prefix = fetch(:sphinx_prefix)    
    run "#{sphinx_prefix}/bin/indexer --config #{shared_path}/config/sphinx.conf --rotate --all"
  end
  
  desc "Build indexex"
  task :index_all do
    sphinx_prefix = fetch(:sphinx_prefix)    
    run "#{sphinx_prefix}/bin/indexer --config #{shared_path}/config/sphinx.conf --all"
  end
  
  desc "Start"
  task :start do
    sudo "/sbin/service sphinx_#{application} start"
  end  
end