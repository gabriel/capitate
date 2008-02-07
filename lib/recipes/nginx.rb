# Nginx recipes
namespace :nginx do
  
  # Callbacks
  after "nginx:setup", "nginx:restart"
    
  desc "Install nginx, conf, initscript, nginx user and service"
  task :install do
    # Dependencies: "pcre-devel", "openssl", "openssl-devel"

    put(load_template("nginx/nginx.initd.erb", binding), "/tmp/nginx.initd")
    put(load_template("nginx/nginx.conf.erb", binding), "/tmp/nginx.conf")
    
    script_install("nginx/install.sh.erb")          
  end
  
  desc "Install nginx monit hooks"
  task :install_monit do
    put load_template("nginx/nginx.monitrc.erb", binding), "/tmp/nginx.monitrc"
    script_install("nginx/install_monit.sh")
  end
  
  
  desc "Create and update the nginx vhost include"
  task :setup do 
    
    ports = (0...mongrel_size).collect { |i| mongrel_port + i }
    public_path = current_path + "/public"
    
    run "mkdir -p #{shared_path}/config"
    put load_template("nginx/nginx_vhost.conf.erb", binding), "/tmp/nginx_#{application}.conf"    
    
    sudo "install -o root /tmp/nginx_#{application}.conf /etc/nginx/vhosts/#{application}.conf"        
  end
    
  # Restart nginx
  task :restart do
    # TODO: Monit
    sudo "/sbin/service nginx restart"
  end
    
end