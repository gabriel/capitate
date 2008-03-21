namespace :nginx do
  
  # Logrotate recipes for nginx
  namespace :logrotate do
    
    desc <<-DESC
    Install logrotated conf for nginx.
    
    *nginx_logrotate_path*: Nginx logrotate path. _Defaults to <tt>/var/log/nginx_*.log</tt>_
    DESC
    task :install do
      fetch_or_default(:nginx_logrotate_path, "/var/log/nginx_*.log")
      
      set :logrotate_name, "nginx_main"
      set :logrotate_log_path, nginx_logrotate_path
      set :logrotate_options, [ { :rotate => 2, :size => "10M" }, :daily, :missingok, :notifempty, :copytruncate ]
      
      logrotated.install_conf      
    end    
    
    desc <<-DESC
    Install logrotated conf for vhost.
    
    *nginx_vhost_logrotate_path*: Nginx logrotate path (for vhost). _Defaults to <tt>{shared_path}/log/nginx.*.log</tt>_    
    DESC
    task :install_vhost do
      fetch_or_default(:nginx_vhost_logrotate_path, "#{shared_path}/log/nginx.*.log")
      
      set :logrotate_name, "nginx_#{application}"
      set :logrotate_log_path, nginx_vhost_logrotate_path
      set :logrotate_options, [ { :rotate => 2, :size => "10M" }, :daily, :missingok, :notifempty, :copytruncate ]
      
      logrotated.install_conf
    end
    
  end
end