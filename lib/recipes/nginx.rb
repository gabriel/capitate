# Nginx recipes
namespace :nginx do
  
  namespace :host do
    
    desc <<-DESC
    Generate the nginx vhost include.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:nginx_upstream_name, "Application name (for upstream definition)", 
      :default => Proc.new { fetch(:application) }, 
      :default_desc => "fetch(:application)")
      
    task_arg(:nginx_upstream_size, "Number of nodes for upstream")
    task_arg(:nginx_upstream_port, "Starting port for upstream. If there are 3 nodes with port 9000, then instances will be at 9000, 9001, and 9002")    
    task_arg(:domain_name, "Domain name")
    task_arg(:nginx_vhost_template, "Path to nginx vhost template", :default => "nginx/nginx_vhost_generic.conf.erb")    
    task :setup do 
    
      set :nginx_upstream_ports, (0...nginx_upstream_size.to_i).collect { |i| nginx_upstream_port.to_i + i }
      set :public_path, current_path + "/public"
    
      utils.install_template(:nginx_vhost_template, "/etc/nginx/vhosts/#{nginx_upstream_name}.conf")
    end
    
  end
  
end