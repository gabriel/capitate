# Nginx recipes
namespace :nginx do
  
  # Callbacks
  after "nginx:setup", "nginx:restart"
    
  desc "Install nginx monit hooks"
  task :install_monit do
    
    # Settings
    nginx_pid_path = profile.get_or_default(:nginx_pid_path, "/var/run/nginx.pid")
    
    put template.load("nginx/nginx.monitrc.erb", binding), "/tmp/nginx.monitrc"    
    sudo "install -o root /tmp/nginx.monitrc /etc/monit/nginx.monitrc"
  end
    
  desc "Create and update the nginx vhost include"
  task :setup do 
    
    ports = (0...mongrel_size).collect { |i| mongrel_port + i }
    public_path = current_path + "/public"
    
    run "mkdir -p #{shared_path}/config"
    put template.load("nginx/nginx_vhost.conf.erb", binding), "/tmp/nginx_#{application}.conf"    
    
    sudo "install -o root /tmp/nginx_#{application}.conf /etc/nginx/vhosts/#{application}.conf"        
  end
    
  # Restart nginx
  task :restart do
    # TODO: Monit
    sudo "/sbin/service nginx restart"
  end
    
end