# Sphinx recipes
namespace :sphinx do
  
  after "sphinx:setup", "sphinx:setup_monit"
  
  desc "Install sphinx"
  task :install do 
    # Dependencies: gcc-c++
    script.install("sphinx/install.sh.erb")
  end
  
  desc "Setup sphinx for application"
  task :setup do 
    
    sphinx_bin_path = "#{sphinx_prefix}/bin"
    sphinx_conf_path = "#{shared_path}/config/sphinx.conf"
    sphinx_pid_path = "#{shared_path}/pids/searchd.pid"
    
    put template.load("sphinx/sphinx_app.initd.centos.erb"), "/tmp/sphinx.initd"

    sudo "install -o root /tmp/sphinx.initd /etc/init.d/sphinx_#{application}"
    
    sudo "/sbin/chkconfig --level 345 sphinx_#{application} on"    
    
    run "mkdir -p #{shared_path}/var/index"    
  end
  
  desc "Create monit configuration for sphinx"
  task :setup_monit do    
    sphinx_pid_path = "#{shared_path}/pids/searchd.pid"
    put template.load("sphinx/sphinx.monitrc.erb"), "/tmp/sphinx_#{application}.monitrc"        
    
    sudo "install -o root /tmp/sphinx_#{application}.monitrc /etc/monit/sphinx_#{application}.monitrc"
  end
  
  desc "Update sphinx for application" 
  task :update_code do
    
    set :rails_root, current_path
    set :index_root, "#{shared_path}/var/index";
    set :log_root, "#{shared_path}/log"
    set :pid_root, "#{shared_path}/pids"
    
    put template.project("config/templates/sphinx.conf.erb"), "#{shared_path}/config/sphinx.conf"
  end
  
  desc "Rotate sphinx index for application"
  task :rotate_all do
    run "#{sphinx_prefix}/bin/indexer --config #{shared_path}/config/sphinx.conf --rotate --all"
  end
  
  desc "Build sphinx indexes for application"
  task :index_all do
    run "#{sphinx_prefix}/bin/indexer --config #{shared_path}/config/sphinx.conf --all"
  end
  
  desc "Start sphinx"
  task :start do
    # TODO: Monit
    sudo "/sbin/service monit restart sphinx_#{application}"
  end  
end