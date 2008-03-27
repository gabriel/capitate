namespace :nginx do
  
  namespace :monit do 
    
    desc <<-DESC 
    Install nginx monit hooks.
  
    <dl>    
    <dt>nginx_pid_path</dt>
    <dd>Path to nginx pid file</dd>
    <dd>Defaults to /var/run/nginx.pid</dd>
    <dd>@set :nginx_pid_path, "/var/run/nginx.pid"@</dd>
    
    <dt>monit_conf_dir</dt>
    <dd>Destination for monitrc.</dd>
    <dd>Defaults to "/etc/monit"</dd>
    <dd>@set :monit_conf_dir, "/etc/monit"@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :install do
    
      # Settings
      fetch_or_default(:nginx_pid_path, "/var/run/nginx.pid")
      fetch_or_default(:monit_conf_dir, "/etc/monit")
    
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