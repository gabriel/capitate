# Nginx recipes
namespace :nginx do
  
  namespace :host do
    
    desc <<-DESC
    Generate the nginx vhost include.
    
    <dl>
    <dt>nginx_upstream_name</dt>
    <dd>Application name (for upstream definition).</dd>
    <dd class="default">Defaults to @:application@</dd>
    
    <dt>nginx_upstream_size</dt>
    <dd>Number of nodes for upstream.</dd>
    <dd>@set :nginx_upstream_size, 3@</dd>  
    
    <dt>nginx_upstream_port</dt>
    <dd>Starting port for upstream. If there are 3 nodes with port 9000, then instances will be at 9000, 9001, and 9002</dd>
    <dd>@set :nginx_upstream_port, 9000@</dd>
    
    <dt>domain_name</dt>: Domain name for nginx virtual host, (without www prefix).</dd>
    <dd>@set :domain_name, "foo.com"@</dd>
    </dl>
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :setup do 
    
      # Settings
      fetch_or_default(:nginx_upstream_name, fetch(:application))
      fetch(:nginx_upstream_size)
      fetch(:nginx_upstream_port)
    
      set :nginx_upstream_ports, (0...nginx_upstream_size.to_i).collect { |i| nginx_upstream_port.to_i + i }
      set :public_path, current_path + "/public"
    
      utils.install_template("nginx/nginx_vhost_generic.conf.erb", "/etc/nginx/vhosts/#{nginx_upstream_name}.conf")
    end
    
  end
  
  namespace :mongrel do
    desc <<-DESC
    Generate the nginx vhost include (for a mongrel setup).
    
    *THIS IS DEPRECATED*: Use @nginx:host:setup@
  
    <dl>
    <dt>mongrel_application</dt>
    <dd>Mongrel application.</dd>
    <dd class="default">Defaults to @:application@</dd>
    
    <dt>mongrel_size</dt>
    <dd>Number of mongrels.</dd>
    <dd>@set :mongrel_size, 3@</dd>  
    
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