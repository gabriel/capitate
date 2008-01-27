# Create init script
namespace :mongrel_cluster do
  
  desc "Install mongrel and mongrel_cluster"
  task :install do 
    sudo "gem install mongrel mongrel_cluster"
  end
  
  desc "Create mongrel cluster"
  task :setup do 
    run "mkdir -p #{shared_path}/config"
    
    # Mongrel cluster config needs its own config directory
    mongrel_config_path = "#{shared_path}/config/mongrel" 
    run "mkdir -p #{mongrel_config_path}"
    
    pid_path = "#{shared_path}/pids"
    
    put load_template("mongrel/mongrel_cluster.erb", binding), "/tmp/mongrel_cluster_#{application}"    
    put load_template("mongrel/mongrel_cluster.yml.erb", binding), "#{mongrel_config_path}/mongrel_cluster.yml"
    
    # Setup the mongrel_cluster init script
    sudo "install -o root /tmp/mongrel_cluster_#{application} /etc/init.d/mongrel_cluster_#{application}"
    sudo "/sbin/chkconfig --level 345 mongrel_cluster_#{application} on"
  end
    
end