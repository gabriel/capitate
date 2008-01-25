# Nginx recipes
namespace :nginx do
  
  task :install do
    put load_file("nginx/nginx"), "/tmp/nginx"    
    sudo "install -o root /tmp/nginx /etc/init.d/nginx"
    sudo "/sbin/chkconfig --level 345 nginx on"
    
    put load_file("nginx/nginx.conf"), "/tmp/nginx.conf"    
    sudo "install -o root -m 644 /tmp/nginx.conf /usr/local/nginx/nginx.conf"
    
    sudo "/usr/sbin/adduser -r nginx"
  end
  
  task :setup do 
    
    ports = (0...mongrel_size).collect { |i| mongrel_port + i }
    public_path = current_path + "/public"
    
    run "mkdir -p #{shared_path}/config"
    put load_template("nginx/nginx_vhost.conf.erb", binding), "#{shared_path}/config/nginx_#{application}.conf"    
    
    # TODO: Include in master nginx.conf
  end
  
  task :update_code do
    # Do nothing
  end
  
end