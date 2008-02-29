# Nginx recipes
namespace :nginx do
  
  namespace :monit do 
    
    desc <<-DESC 
    Install nginx monit hooks.
  
    *nginx_pid_path*: Path to nginx pid file. _Defaults to /var/run/nginx.pid_\n  
    @set :nginx_pid_path, "/var/run/nginx.pid"@\n  
    *monit_conf_dir*: Destination for monitrc. _Defaults to "/etc/monit"_\n
    @set :monit_conf_dir, "/etc/monit"@\n  
    DESC
    task :install do
    
      # Settings
      fetch_or_default(:nginx_pid_path, "/var/run/nginx.pid")
      fetch_or_default(:monit_conf_dir, "/etc/monit")
    
      put template.load("nginx/nginx.monitrc.erb", binding), "/tmp/nginx.monitrc"    
      run_via "install -o root /tmp/nginx.monitrc #{monit_conf_dir}/nginx.monitrc"
    end
    
  end
    
  namespace :mongrel do
    desc <<-DESC
    Generate the nginx vhost include (for a mongrel setup).
  
    *mongrel_application*: Mongrel application. _Defaults to <tt>:application</tt>_
    *mongrel_size*: Number of mongrels.\n
    @set :mongrel_size, 3@\n    
    *mongrel_port*: Starting port for mongrels.\n
    If there are 3 mongrels with port 9000, then instances will be at 9000, 9001, and 9002\n
    @set :mongrel_port, 9000@\n
    *domain_name*: Domain name for nginx virtual host, (without www prefix).\n  
    @set :domain_name, "foo.com"@
    DESC
    task :setup do 
    
      # Settings
      fetch(:mongrel_size)
      fetch(:mongrel_port)
      fetch(:domain_name)
      fetch_or_default(:mongrel_application, fetch(:application))
    
      set :ports, (0...mongrel_size).collect { |i| mongrel_port + i }
      set :public_path, current_path + "/public"
    
      run "mkdir -p #{shared_path}/config"
      put template.load("nginx/nginx_vhost.conf.erb"), "/tmp/nginx_#{mongrel_application}.conf"    
    
      sudo "install -o root /tmp/nginx_#{mongrel_application}.conf /etc/nginx/vhosts/#{mongrel_application}.conf"        
    end
  end
        
end