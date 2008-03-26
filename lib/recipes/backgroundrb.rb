namespace :backgroundrb do
  
  desc <<-DESC
  Create backgroundrb.yml configuration.
  
  For pid path support, change backgroundrb script pid_file line to:
  
    pid_file = "\#{CONFIG_FILE[:backgroundrb][:pid_file]}"
  
  <dl>
    <dt>backgroundrb_host</dt>
    <dd>Backgroundrb host</dd>
    <dd class="default">Defaults to @0.0.0.0@</dd>
    
    <dt>backgroundrb_port</dt>
    <dd>Backgroundrb port</dd>
    <dd class="default">Defaults to @11006@</dd>
  
    <dt>backgroundrb_yml_template</dt>
    <dd>Backgroundrb yml template</dd>
    <dd class="default">Defaults to @backgroundrb/backgroundrb.yml.erb@ in this gem.</dd>
  </dl>
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :setup do
    fetch_or_default(:backgroundrb_host, "0.0.0.0")
    fetch_or_default(:backgroundrb_port, 11006)
    fetch_or_default(:backgroundrb_pid_path, "#{shared_path}/pids/backgroundrb.pid")
    fetch_or_default(:backgroundrb_yml_template, "backgroundrb/backgroundrb.yml.erb")
    
    utils.install_template(backgroundrb_yml_template, "#{shared_path}/config/backgroundrb.yml")    
  end
  
  desc <<-DESC
  Symlink backgroundrb config into current path.  
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :update_code do
    run "ln -nfs #{shared_path}/config/backgroundrb.yml #{release_path}/config/backgroundrb.yml" 
  end
  
end