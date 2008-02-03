# Nginx recipes
namespace :nginx do
  
  after "nginx:setup", "nginx:setup_monit"
  
  # Conf variables
  set :nginx_bin_path, "/sbin/nginx"
  set :nginx_conf_path, "/etc/nginx/nginx.conf"
  set :nginx_pid_path, "/var/run/nginx.pid"
  set :nginx_prefix_path, "/var/nginx"
  
  # Callbacks
  after "nginx:setup", "nginx:restart"
    
  desc "Install nginx, conf, initscript, nginx user and service"
  task :install do
    package_install([ "pcre-devel", "openssl", "openssl-devel" ])

    run("rm -rf /tmp/nginx && mkdir -p /tmp/nginx")
    
    put(load_template("nginx/nginx.initd.erb", binding), "/tmp/nginx/nginx.initd")
    put(load_template("nginx/nginx.conf.erb", binding), "/tmp/nginx/nginx.conf")
    
    script_install("nginx/install.sh.erb")  
  end
  
  desc "Create and update the nginx vhost include"
  task :setup do 
    
    ports = (0...mongrel_size).collect { |i| mongrel_port + i }
    public_path = current_path + "/public"
    
    run "mkdir -p #{shared_path}/config"
    put load_template("nginx/nginx_vhost.conf.erb", binding), "/tmp/nginx_#{application}.conf"    
    
    sudo "install -o root /tmp/nginx_#{application}.conf /etc/nginx/vhosts/#{application}.conf"        
  end
  
  desc "Create monit configuration for nginx"
  task :setup_monit do
    put load_template("nginx/nginx.monitrc.erb", binding), "/tmp/nginx.monitrc"
    
    sudo "install -o root /tmp/nginx.monitrc /etc/monit/nginx.monitrc"
  end
  
  # Restart nginx
  task :restart do
    sudo "/sbin/service nginx restart"
  end
    
end