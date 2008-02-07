# Create init script
namespace :mongrel_cluster do
  
  after "mongrel_cluster:setup", "mongrel_cluster:setup_monit"
    
  desc "Create mongrel cluster"
  task :setup do 
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
  
  desc "Create monit configuration for mongrel cluster"
  task :setup_monit do
    
    # see http://www.igvita.com/2006/11/07/monit-makes-mongrel-play-nice/
    
    # TODO: For depends on memcached setting
    # see http://blog.labratz.net/articles/2007/5/1/monit-for-your-uptime 
    
    processes = []
    ports = (0...mongrel_size).collect { |i| mongrel_port + i }
    ports.each do |port|
      
      pid_path = "#{shared_path}/pids/mongrel.#{port}.pid"
      start_options = "-d -e production -a 127.0.0.1 -c #{current_path} --user #{user} --group #{user} -p #{port} -P #{pid_path} -l log/mongrel.#{port}.log"
      stop_options = "-p #{port} -P #{pid_path}"
      
      processes << { :port => port, :start_options => start_options, :stop_options => stop_options, :name => "/usr/bin/mongrel_rails", :pid_path => pid_path }
    end
    
    put template.load("mongrel/mongrel_cluster.monitrc.erb", binding), "/tmp/mongrel_cluster_#{application}.monitrc"
    
    sudo "install -o root /tmp/mongrel_cluster_#{application}.monitrc /etc/monit/mongrel_cluster_#{application}.monitrc"
  end
    
end