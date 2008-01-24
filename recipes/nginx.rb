# Nginx recipes
namespace :nginx do
  
  task :setup do 
    
    ports = (0...mongrel_size).collect { |i| mongrel_port + i }
    
    run "mkdir -p #{shared_path}/config"
    put load_template("nginx/nginx_include.conf.erb", binding), "#{shared_path}/config/nginx_#{application}.conf"    
    
    run "ln -nfs #{shared_path}/config/sphinx.conf #{release_path}/config/sphinx.conf"
  end
  
  task :update_code do
    # Do nothing
  end
  
end