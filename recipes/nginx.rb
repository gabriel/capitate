# Nginx recipes
namespace :nginx do
    
  desc "Install nginx, conf, initscript, nginx user and service"
  task :install do
    yum_install([ "pcre-devel", "openssl", "openssl-devel" ])

    run("rm -rf /tmp/nginx && mkdir -p /tmp/nginx")
    
    put(load_file("nginx/nginx"), "/tmp/nginx/nginx.initd")
    put(load_file("nginx/nginx.conf"), "/tmp/nginx/nginx.conf")
    
    install_script("nginx/install.sh")  
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