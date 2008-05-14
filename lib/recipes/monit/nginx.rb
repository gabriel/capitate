namespace :nginx do
  
  namespace :monit do 
    
    desc <<-DESC 
    Install nginx monit hooks.
  
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:nginx_pid_path, "Path to nginx pid file", :default => "/var/run/nginx.pid")
    task_arg(:monit_conf_dir, "Destination for monitrc", :default => "/etc/monit")
    task :install do
      put template.load("nginx/nginx.monitrc.erb", binding), "/tmp/nginx.monitrc"    
      run_via "install -o root /tmp/nginx.monitrc #{monit_conf_dir}/nginx.monitrc"
    end
        
    desc "Restart nginx (through monit)"
    task :restart do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} restart nginx"
    end
    
    desc "Start nginx (through monit)"
    task :start do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} start nginx" 
    end
    
    desc "Stop nginx (through monit)"
    task :stop do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} stop nginx"
    end
    
  end
  
end