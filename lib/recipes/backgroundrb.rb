namespace :backgroundrb do
  
  desc <<-DESC
  Create backgroundrb.yml configuration.
  
  For pid path support, change backgroundrb script pid_file line to:
  
    pid_file = "\#{CONFIG_FILE[:backgroundrb][:pid_file]}"
    
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:backgroundrb_host, "Backgroundrb host", :default => "0.0.0.0")
  task_arg(:backgroundrb_port, "Backgroundrb port", :default => 11006)
  task_arg(:backgroundrb_pid_path, "Backgroundrb pid path", :default => Proc.new{"#{shared_path}/pids/backgroundrb.pid"}, :default_desc => "\#{shared_path}/pids/backgroundrb.pid")
  task_arg(:backgroundrb_yml_template, "Backgroundrb yml template", :default => "backgroundrb/backgroundrb.yml.erb")  
  task :setup do
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