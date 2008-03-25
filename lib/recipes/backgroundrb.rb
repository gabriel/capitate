namespace :backgroundrb do
  
  desc <<-DESC
  Create backgroundrb.yml configuration.
  
  For pid path support, change backgroundrb script pid_file line to:
  
    pid_file = "\#{CONFIG_FILE[:backgroundrb][:pid_file]}"
  
  *backgroundrb_host*: Backgroundrb host. _Defaults to 0.0.0.0_\n
  *backgroundrb_port*: Backgroundrb port. _Defaults to 11006_\n
  *backgroundrb_yml_template*: Backgroundrb yml template. _Defaults to @backgroundrb/backgroundrb.yml.erb@ in this gem.\n
  DESC
  task :setup do
    fetch_or_default(:backgroundrb_host, "0.0.0.0")
    fetch_or_default(:backgroundrb_port, 11006)
    fetch_or_default(:backgroundrb_pid_path, "#{shared_path}/pids/backgroundrb.pid")
    fetch_or_default(:backgroundrb_yml_template, "backgroundrb/backgroundrb.yml.erb")
    
    utils.install_template(backgroundrb_yml_template, "#{shared_path}/config/backgroundrb.yml")    
  end
  
  desc <<-DESC
  Symlink backgroundrb config into release path.  
  DESC
  task :update_code do
    run "ln -nfs #{shared_path}/config/backgroundrb.yml #{release_path}/config/backgroundrb.yml" 
  end
  
end