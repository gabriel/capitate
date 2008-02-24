namespace :mongrel_cluster do 
  
  namespace :centos do
    
    desc <<-DESC
    Create mongrel cluster.
    
    *mongrel_size*: Number of mongrels.\n    
    @set :mongrel_size, 3@\n
    *mongrel_port*: Starting port for mongrels. If there are 3 mongrels with port 9000, 
    then instances will be at 9000, 9001, and 9002\n      
    @set :mongrel_port, 9000@\n      
    DESC
    task :setup do 

      # Settings
      fetch(:mongrel_size)
      fetch(:mongrel_port)
      
      run "mkdir -p #{shared_path}/config"

      # Mongrel cluster config needs its own config directory
      mongrel_config_path = "#{shared_path}/config/mongrel" 
      run "mkdir -p #{mongrel_config_path}"

      pid_path = "#{shared_path}/pids"

      put template.load("mongrel/mongrel_cluster.initd.erb"), "/tmp/mongrel_cluster_#{application}.initd"    
      put template.load("mongrel/mongrel_cluster.yml.erb"), "#{mongrel_config_path}/mongrel_cluster.yml"

      # Setup the mongrel_cluster init script
      sudo "install -o root /tmp/mongrel_cluster_#{application}.initd /etc/init.d/mongrel_cluster_#{application}"

      sudo "/sbin/chkconfig --level 345 mongrel_cluster_#{application} on"
    end
    
    
  end
  
end