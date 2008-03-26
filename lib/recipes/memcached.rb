namespace :memcached do
  
  desc "Create memcached yaml in shared path."
  task :setup do    

    # Settings
    fetch(:memcached_namespace)
    fetch_or_default(:memcached_ttl, 3600)
    fetch_or_default(:memcached_readonly, false)
    fetch_or_default(:memcached_urlencode, false)
    fetch_or_default(:memcached_c_threshold, 10000)
    fetch_or_default(:memcached_compression, true)
    fetch_or_default(:memcached_debug, false)
    fetch_or_default(:memcached_servers, [ "localhost:11211" ])
    fetch_or_default(:memcached_yml_template, "memcached/memcached.yml.erb")    

    utils.install_template(memcached_yml_template, "#{shared_path}/config/memcached.yml")
  end

  desc "Symlink memcached configuration after deploy."
  task :update_code, :roles => :app do 
    run "ln -nfs #{shared_path}/config/memcached.yml #{release_path}/config/memcached.yml" 
  end
    
end