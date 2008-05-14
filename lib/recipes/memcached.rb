namespace :memcached do
  
  desc <<-DESC
  Create memcached yaml in shared path.
    
  "Source":#{link_to_source(__FILE__)}   
  DESC
  task_arg(:memcached_namespace, "Namespace")
  task_arg(:memcached_ttl, "TTL in seconds", :default => 3600)
  task_arg(:memcached_readonly, "Read only enabled", :default => false)
  task_arg(:memcached_urlencode, "URL encode enabled", :default => false)
  task_arg(:memcached_c_threshold, "C Threshold", :default => 10000)
  task_arg(:memcached_compression, "Compression enabed", :default => true)
  task_arg(:memcached_debug, "Debug enabled", :default => false)
  task_arg(:memcached_servers, "List of servers", :default => ["localhost:11211"], :default_desc => "[\"localhost:11211\"]")
  task_arg(:memcached_yml_template, "Memcached yml template", :default => "memcached/memcached.yml.erb")
  task :setup do
    put(memcached_yml_template, "#{shared_path}/config/memcached.yml")
  end

  desc "Symlink memcached configuration after deploy."
  task :update_code, :roles => :app do 
    run "ln -nfs #{shared_path}/config/memcached.yml #{release_path}/config/memcached.yml" 
  end
    
end