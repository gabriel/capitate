# Nginx recipes
namespace :nginx do
    
  desc "Creates nginx conf, initscript, nginx user and installs as service"
  task :install do
    put load_file("nginx/install.sh"), "/tmp/nginx_install.sh"
    put load_file("nginx/nginx"), "/tmp/nginx"    
    put load_file("nginx/nginx.conf"), "/tmp/nginx.conf" 
    
    sudo "sh -v /tmp/nginx_install.sh"    
  end
  
  desc "Create and update the nginx vhost include"
  task :setup do 
    
    ports = (0...mongrel_size).collect { |i| mongrel_port + i }
    public_path = current_path + "/public"
    
    run "mkdir -p #{shared_path}/config"
    put load_template("nginx/nginx_vhost.conf.erb", binding), "#{shared_path}/config/nginx_#{application}.conf"    
    
    # TODO: Include in sites-available
  end
    
end