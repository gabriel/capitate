namespace :memcached do
  
  desc <<-DESC
  Create memcached yaml in shared path.
    
  <dl>
  <dt>memcached_namespace</dt>
  
  <dt>memcached_ttl</dt>
  <dd class="default">Defaults to @3600@</dd>
  
  <dt>memcached_readonly</dt>
  <dd class="default">Defaults to @false@</dd>
  
  <dt>memcached_urlencode</dt>
  <dd class="default">Defaults to @false@</dd>
  
  <dt>memcached_c_threshold</dt>
  <dd class="default">Defaults to @10000@</dd>
  
  <dt>memcached_compression</dt>
  <dd class="default">Defaults to @true@</dd>
  
  <dt>memcached_debug</dt>
  <dd class="default">Defaults to @false@</dd>
  
  <dt>memcached_servers</dt>
  <dd class="default">Defaults to @[ "localhost:11211" ]@</dd>
  
  <dt>memcached_yml_template</dt>
  <dd class="default">Defaults to @"memcached/memcached.yml.erb"@</dd>
  </dl>
  
  "Source":#{link_to_source(__FILE__)}   
  DESC
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

    put(memcached_yml_template, "#{shared_path}/config/memcached.yml")
  end

  desc "Symlink memcached configuration after deploy."
  task :update_code, :roles => :app do 
    run "ln -nfs #{shared_path}/config/memcached.yml #{release_path}/config/memcached.yml" 
  end
    
end