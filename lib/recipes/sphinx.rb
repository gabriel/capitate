# Sphinx recipes
namespace :sphinx do
  
  namespace :monit do
  
    desc <<-DESC
    Create monit configuration for sphinx.\n  
    *monit_conf_dir*: Destination for monitrc. _Defaults to "/etc/monit"_\n
    *sphinx_pid_path*: Location for sphinx pid. _Defaults to "[shared_path]/pids/searchd.pid"_\n
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :setup do    
    
      # Settings
      fetch_or_default(:monit_conf_dir, "/etc/monit")
      fetch_or_default(:sphinx_pid_path, "#{shared_path}/pids/searchd.pid")
    
      put template.load("sphinx/sphinx.monitrc.erb"), "/tmp/sphinx_#{application}.monitrc"            
      sudo "install -o root /tmp/sphinx_#{application}.monitrc #{monit_conf_dir}/sphinx_#{application}.monitrc"
    end
    
  end
  
  desc <<-DESC
  Update sphinx for application.
  
  *sphinx_conf_template*: Path to sphinx.conf.erb. _Defaults to "config/templates/sphinx.conf.erb"_\n
  *sphinx_conf_path*: Path to sphinx.conf. _Defaults to "[shared_path]/config/sphinx.conf"_\n
  *sphinx_port*: Sphinx port. _Defaults to 3312_\n
  *sphinx_conf_root*: Directory for sphinx configuration, like stopwords.txt. _Defaults to [current_path]/config_\n
  *sphinx_index_root*: Directory for sphinx indexes. _Defaults to "[shared_path]/var/index"_\n
  *sphinx_log_root*: Directory for sphinx logs. _Defaults to "[shared_path]/log"_\n
  *sphinx_pid_root*: Directory for sphinx pids. _Defaults to "[shared_path]/pids"_\n
  
  *sphinx_db_user*: Sphinx DB user. _Defaults to db_user_\n
  *sphinx_db_pass*: Sphinx DB password. _Defaults to db_pass_\n
  *sphinx_db_name*: Sphinx DB name. _Defaults to db_name_\n
  *sphinx_db_port*: Sphinx DB port. _Defaults to db_port_\n
  
  *sphinx_db_host*: Sphinx DB host. _Defaults to db_host_\n
  *sphinx_conf_host*: Sphinx DB host to listen on. _Defaults to 127.0.0.1_\n
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :update_conf do
    
    fetch_or_default(:sphinx_conf_template, "config/templates/sphinx.conf.erb")        
    fetch_or_default(:sphinx_port, 3312)
    fetch_or_default(:sphinx_conf_path, "#{shared_path}/config/sphinx.conf")
    fetch_or_default(:sphinx_conf_root, "#{current_path}/config")
    fetch_or_default(:sphinx_index_root, "#{shared_path}/var/index")
    fetch_or_default(:sphinx_log_root, "#{shared_path}/log")
    fetch_or_default(:sphinx_pid_path, "#{shared_path}/pids/searchd.pid")    
    
    fetch_or_set(:sphinx_db_user, :db_user)
    fetch_or_set(:sphinx_db_pass, :db_pass)
    fetch_or_set(:sphinx_db_name, :db_name)
    fetch_or_set(:sphinx_db_port, :db_port)
    fetch_or_set(:sphinx_db_host, :db_host)
    fetch_or_default(:sphinx_conf_host, "127.0.0.1")
        
    put template.load(sphinx_conf_template), sphinx_conf_path
  end
  
  desc <<-DESC
  Rotate sphinx index for application.
  
  *sphinx_prefix*: Location to sphinx install. _Defaults to nil_\n
  *sphinx_conf*: Location to sphinx conf. _Defaults to "[shared_path]/config/sphinx.conf"_\n  
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :rotate_all do
    fetch_or_default(:sphinx_prefix, nil)
    fetch_or_default(:sphinx_conf, "#{shared_path}/config/sphinx.conf")
    
    indexer_path = sphinx_prefix ? "#{sphinx_prefix}/bin/indexer" : "indexer"
    
    run "#{indexer_path} --config #{sphinx_conf} --rotate --all"
  end
  
  desc <<-DESC
  Build sphinx indexes for application.
  
  *sphinx_prefix*: Location to sphinx install. _Defaults to nil_\n
  *sphinx_conf*: Location to sphinx conf. _Defaults to "[shared_path]/config/sphinx.conf"_\n
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :index_all do
    fetch_or_default(:sphinx_prefix, nil)
    fetch_or_default(:sphinx_conf, "#{shared_path}/config/sphinx.conf")
    
    indexer_path = sphinx_prefix ? "#{sphinx_prefix}/bin/indexer" : "indexer"
    
    run "#{indexer_path} --config #{sphinx_conf} --all"
  end
  
  desc "Restart sphinx"
  task :restart do
    sudo "/sbin/service monit restart sphinx_#{application}"
  end  
end