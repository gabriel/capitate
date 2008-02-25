namespace :mongrel_cluster do 
  
  namespace :centos do
    
    desc <<-DESC
    Create mongrel cluster.
    
    *mongrel_size*: Number of mongrels.\n    
    @set :mongrel_size, 3@\n
    *mongrel_port*: Starting port for mongrels. If there are 3 mongrels with port 9000, 
    then instances will be at 9000, 9001, and 9002\n      
    @set :mongrel_port, 9000@\n      
    *mongrel_config_dir*: Directory for mongrel config. _Defaults to "[shared_path]/config/mongrel"_
    *mongrel_pid_dir*: Directory for mongrel pids. _Defaults to "[shared_path]/pids"
    *mongrel_config_script*: Config script to load with mongrel. _Defaults to nil_\n  
    @set :mongrel_config_script, "config/mongrel_handler.rb"@\n
    DESC
    task :setup do 

      # Settings
      fetch(:mongrel_size)
      fetch(:mongrel_port)
      fetch_or_default(:mongrel_config_dir, "#{shared_path}/config/mongrel")
      fetch_or_default(:mongrel_pid_dir, "#{shared_path}/pids")
      fetch_or_default(:mongrel_config_script, nil)
      
      run "mkdir -p #{mongrel_config_dir}"

      put template.load("mongrel/mongrel_cluster.initd.erb"), "/tmp/mongrel_cluster_#{application}.initd"    
      put template.load("mongrel/mongrel_cluster.yml.erb"), "#{mongrel_config_dir}/mongrel_cluster.yml"

      # Setup the mongrel_cluster init script
      sudo "install -o root /tmp/mongrel_cluster_#{application}.initd /etc/init.d/mongrel_cluster_#{application}"

      sudo "/sbin/chkconfig --level 345 mongrel_cluster_#{application} on"
    end
    
    
  end
  
end