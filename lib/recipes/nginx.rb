# Nginx recipes
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
    
  end
    
  namespace :mongrel do
    desc <<-DESC
    Generate the nginx vhost include (for a mongrel setup).
  
    <dl>
    <dt>mongrel_application</dt>
    <dd>Mongrel application. _Defaults to <tt>:application</tt>_
    
    <dt>mongrel_size</dt>: Number of mongrels.\n
    <dd>@set :mongrel_size, 3@\n    
    
    <dt>*mongrel_port</dt>
    <dd>Starting port for mongrels. If there are 3 mongrels with port 9000, then instances will be at 9000, 9001, and 9002</dd>
    <dd>@set :mongrel_port, 9000@</dd>
    
    <dt>domain_name</dt>: Domain name for nginx virtual host, (without www prefix).</dd>
    <dd>@set :domain_name, "foo.com"@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}
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