# Sphinx recipes
namespace :sphinx do
  
  desc <<-DESC
  Create monit configuration for sphinx.
  
  *monit_conf_dir*: Destination for monitrc. _Defaults to "/etc/monit"_

  @set :monit_conf_dir, "/etc/monit"@
  
  DESC
  task :setup_monit do    
    
    # Settings
    fetch_or_default(:monit_conf_dir, "/etc/monit")
    
    set :sphinx_pid_path, "#{shared_path}/pids/searchd.pid"
    
    put template.load("sphinx/sphinx.monitrc.erb"), "/tmp/sphinx_#{application}.monitrc"            
    sudo "install -o root /tmp/sphinx_#{application}.monitrc #{monit_conf_dir}/sphinx_#{application}.monitrc"
  end
  
  desc "Update sphinx for application" 
  task :update_code do
    
    set :rails_root, current_path
    set :index_root, "#{shared_path}/var/index";
    set :log_root, "#{shared_path}/log"
    set :pid_root, "#{shared_path}/pids"
    
    put template.load("config/templates/sphinx.conf.erb"), "#{shared_path}/config/sphinx.conf"
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