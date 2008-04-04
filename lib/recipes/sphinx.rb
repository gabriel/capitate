# Sphinx recipes
namespace :sphinx do
  
  desc <<-DESC
  Update sphinx for application.
  
  <dl>
  <dt>sphinx_conf_template</dt><dd>Path to sphinx.conf.erb.</dd><dd>_Defaults to "config/templates/sphinx.conf.erb"_</dd>
  <dt>sphinx_conf_path</dt><dd>Path to sphinx.conf.</dd><dd>_Defaults to "[shared_path]/config/sphinx.conf"_</dd>
  <dt>sphinx_port</dt><dd>Sphinx port.</dd><dd>_Defaults to 3312_</dd>
  <dt>sphinx_conf_root</dt><dd>Directory for sphinx configuration, like stopwords.txt.</dd><dd>_Defaults to [current_path]/config_</dd>
  <dt>sphinx_index_root</dt><dd>Directory for sphinx indexes.</dd><dd>_Defaults to "[shared_path]/var/index"_</dd>
  <dt>sphinx_log_root</dt><dd>Directory for sphinx logs.</dd><dd>_Defaults to "[shared_path]/log"_</dd>
  <dt>sphinx_pid_root</dt><dd>Directory for sphinx pids.</dd><dd>_Defaults to "[shared_path]/pids"_</dd>
  
  <dt>sphinx_db_user</dt><dd>Sphinx DB user.</dd><dd>_Defaults to db_user_</dd>
  <dt>sphinx_db_pass</dt><dd>Sphinx DB password.</dd><dd>_Defaults to db_pass_</dd>
  <dt>sphinx_db_name</dt><dd>Sphinx DB name.</dd><dd>_Defaults to db_name_</dd>
  <dt>sphinx_db_port</dt><dd>Sphinx DB port.</dd><dd>_Defaults to db_port_</dd>
  
  <dt>sphinx_db_host</dt><dd>Sphinx DB host.</dd><dd>_Defaults to db_host_</dd>
  <dt>sphinx_conf_host</dt><dd>Sphinx DB host to listen on.</dd><dd>_Defaults to 127.0.0.1_</dd>
  
  </dl>
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
    fetch_or_default(:sphinx_hostname, Proc.new { utils.hostname }) # Runs if needed
    
    fetch_or_set(:sphinx_db_user, :db_user)
    fetch_or_set(:sphinx_db_pass, :db_pass)
    fetch_or_set(:sphinx_db_name, :db_name)
    fetch_or_set(:sphinx_db_port, :db_port)
    fetch_or_set(:sphinx_db_host, :db_host)
    fetch_or_default(:sphinx_conf_host, "127.0.0.1")
        
    put template.load(sphinx_conf_template), sphinx_conf_path
  end
  
  desc "Make symlink for sphinx conf" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/sphinx.conf #{release_path}/config/sphinx.conf" 
  end
  
  desc <<-DESC
  Rotate sphinx index for application.
  
  *sphinx_prefix*<dd>Location to sphinx install. _Defaults to nil_\n
  *sphinx_conf*<dd>Location to sphinx conf. _Defaults to "[shared_path]/config/sphinx.conf"_\n  
  
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
  
  *sphinx_prefix*<dd>Location to sphinx install. _Defaults to nil_\n
  *sphinx_conf*<dd>Location to sphinx conf. _Defaults to "[shared_path]/config/sphinx.conf"_\n
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :index_all do
    fetch_or_default(:sphinx_prefix, nil)
    fetch_or_default(:sphinx_conf, "#{shared_path}/config/sphinx.conf")
    
    indexer_path = sphinx_prefix ? "#{sphinx_prefix}/bin/indexer" : "indexer"
    
    run "#{indexer_path} --config #{sphinx_conf} --all"
  end
    
end