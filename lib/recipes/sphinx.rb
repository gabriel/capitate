# Sphinx recipes
namespace :sphinx do
  
  desc <<-DESC
  Update sphinx conf for application.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:sphinx_conf_template, "Path to sphinx.conf.erb template", :default => "config/templates/sphinx.conf.erb")        
  task_arg(:sphinx_port, "Sphinx port", :default => 3312)
  task_arg(:sphinx_conf_path, "Path to sphinx.conf", :default => Proc.new {"#{shared_path}/config/sphinx.conf"}, :default_desc => "\#{shared_path}/config/sphinx.conf")
  task_arg(:sphinx_conf_root, "Directory for sphinx configuration, like stopwords.txt", :default => Proc.new {"#{current_path}/config"}, :default_desc => "\#{current_path}/config")
  task_arg(:sphinx_index_root, "Directory for sphinx indexes", :default => Proc.new {"#{shared_path}/var/index"}, :default_desc => "\#{shared_path}/var/index")
  task_arg(:sphinx_log_root, "Directory for sphinx logs", :default => Proc.new {"#{shared_path}/log"}, :default_desc => "\#{shared_path}/log")
  task_arg(:sphinx_pid_path, "Directory for sphinx pids", :default => Proc.new {"#{shared_path}/pids/searchd.pid"}, :default_desc => "\#{shared_path}/pids/searchd.pid")
  
  task_arg(:sphinx_db_user, "Sphinx DB user", :set => :db_user)
  task_arg(:sphinx_db_pass, "Sphinx DB password", :set => :db_pass)
  task_arg(:sphinx_db_name, "Sphinx DB name", :set => :db_name)
  task_arg(:sphinx_db_port, "Sphinx DB port", :set => :db_port)
  task_arg(:sphinx_db_host, "Sphinx DB host", :set => :db_host)
  
  task_arg(:sphinx_conf_host, "Sphinx DB host to listen on", :default => "127.0.0.1")
  task :update_conf do
    put(template.load(sphinx_conf_template), sphinx_conf_path)        
  end
  
  desc "Make symlink for sphinx conf" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/sphinx.conf #{release_path}/config/sphinx.conf" 
  end
  
  desc <<-DESC
  Rotate sphinx index for application.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:sphinx_prefix, :default => nil)
  task_arg(:sphinx_conf, :default => Proc.new{"#{shared_path}/config/sphinx.conf"}, :default_desc => "\#{shared_path}/config/sphinx.conf")  
  task :rotate_all do
    indexer_path = sphinx_prefix ? "#{sphinx_prefix}/bin/indexer" : "indexer"
    run "#{indexer_path} --config #{sphinx_conf} --rotate --all"
  end
  
  desc <<-DESC
  Build sphinx indexes for application.
  
  *sphinx_prefix*<dd>Location to sphinx install. _Defaults to nil_\n
  *sphinx_conf*<dd>Location to sphinx conf. _Defaults to "[shared_path]/config/sphinx.conf"_\n
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:sphinx_prefix, :default => nil)
  task_arg(:sphinx_conf, :default => Proc.new{"#{shared_path}/config/sphinx.conf"}, :default_desc => "\#{shared_path}/config/sphinx.conf")    
  task :index_all do
    indexer_path = sphinx_prefix ? "#{sphinx_prefix}/bin/indexer" : "indexer"
    run "#{indexer_path} --config #{sphinx_conf} --all"
  end
    
end