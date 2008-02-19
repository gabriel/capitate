namespace :centos do 
  
  namespace :mongrel_cluster do
    
    after "centos:mongrel_cluster:setup", "mongrel_cluster:setup_monit"  
    
    desc "Create mongrel cluster"
    task :setup do 
      
      # Settings
      fetch(:mongrel_size)
      fetch(:mongrel_port)
      
      run "mkdir -p #{shared_path}/config"

      # Mongrel cluster config needs its own config directory
      mongrel_config_path = "#{shared_path}/config/mongrel" 
      run "mkdir -p #{mongrel_config_path}"

      pid_path = "#{shared_path}/pids"

      put template.load("mongrel/mongrel_cluster.initd.erb", binding), "/tmp/mongrel_cluster_#{application}.initd"    
      put template.load("mongrel/mongrel_cluster.yml.erb", binding), "#{mongrel_config_path}/mongrel_cluster.yml"

      # Setup the mongrel_cluster init script
      sudo "install -o root /tmp/mongrel_cluster_#{application}.initd /etc/init.d/mongrel_cluster_#{application}"

      sudo "/sbin/chkconfig --level 345 mongrel_cluster_#{application} on"
    end
    
    
  end
  
end