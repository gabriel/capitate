namespace :nginx do 
  
  namespace :centos do
    
    desc <<-DESC
    Install nginx, conf, initscript, nginx user and service.
    
    *nginx_build_options*: Nginx build options.\n
    *nginx_bin_path*: Nginx sbin path. _Defaults to /sbin/nginx_\n    
    @set :nginx_bin_path, "/sbin/nginx"@\n
    *nginx_conf_path*: Path to nginx conf. _Defaults to /etc/nginx/nginx.conf_\n    
    @set :nginx_conf_path, "/etc/nginx/nginx.conf"@\n
    *nginx_pid_path*: Path to nginx pid file. _Defaults to /var/run/nginx.pid_\n    
    @set :nginx_pid_path, "/var/run/nginx.pid"@\n
    *nginx_prefix_path*: Nginx install prefix. _Defaults to /var/nginx_\n    
    @set :nginx_prefix_path, "/var/nginx"@\n      
    DESC
    task :install do
      
      # Settings
      fetch(:nginx_build_options)
      fetch_or_default(:nginx_bin_path, "/sbin/nginx")
      fetch_or_default(:nginx_conf_path, "/etc/nginx/nginx.conf")
      fetch_or_default(:nginx_pid_path, "/var/run/nginx.pid")
      fetch_or_default(:nginx_prefix_path, "/var/nginx")      
            
      # Install dependencies
      yum.install([ "pcre-devel", "openssl", "openssl-devel" ]) 
            
      # Build
      script.make_install("nginx", nginx_build_options)

      # Install initscript, and turn it on
      put template.load("nginx/nginx.initd.erb"), "/tmp/nginx.initd"
      run_via "install -o root /tmp/nginx.initd /etc/init.d/nginx && rm -f /tmp/nginx.initd"
      run_via "/sbin/chkconfig --level 345 nginx on"

      # Setup nginx
      run_via "mkdir -p /etc/nginx/vhosts"
      run_via "echo \"# Blank nginx conf; work-around for nginx conf include issue\" > /etc/nginx/vhosts/blank.conf"
      put template.load("nginx/nginx.conf.erb", binding), "/tmp/nginx.conf"
      run_via "install -o root -m 644 /tmp/nginx.conf #{nginx_conf_path} && rm -f /tmp/nginx.conf"

      # Create nginx user
      run_via "id nginx || /usr/sbin/adduser -r nginx"
    end
    
    # Restart nginx
    desc "Restart nginx (service)"
    task :restart do
      # TODO: Monit
      sudo "/sbin/service nginx restart"
    end
    
    
  end
  
end