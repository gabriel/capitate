# Create init script
namespace :mongrel_cluster do

  desc <<-DESC
  Create monit configuration for mongrel cluster.
  
  mongrel_size: Number of mongrels.
  
    set :mongrel_size, 3

  mongrel_port: Starting port for mongrels. If there are 3 mongrels with port 9000, then instances 
  will be at 9000, 9001, and 9002
    
    set :mongrel_port, 9000
    
  DESC
  task :setup_monit do
    
    # See http://www.igvita.com/2006/11/07/monit-makes-mongrel-play-nice/
    
    # TODO: For depends on memcached setting
    # See http://blog.labratz.net/articles/2007/5/1/monit-for-your-uptime 
    
    # Settings
    fetch(:mongrel_size)
    fetch(:mongrel_port)
    
    processes = []
    ports = (0...mongrel_size).collect { |i| mongrel_port + i }
    ports.each do |port|
      
      pid_path = "#{shared_path}/pids/mongrel.#{port}.pid"
      start_options = "-d -e production -a 127.0.0.1 -c #{current_path} --user #{user} --group #{user} -p #{port} -P #{pid_path} -l log/mongrel.#{port}.log"
      stop_options = "-p #{port} -P #{pid_path}"
      
      processes << { :port => port, :start_options => start_options, :stop_options => stop_options, :name => "/usr/bin/mongrel_rails", :pid_path => pid_path }
    end
    
    set :processes, processes
    
    put template.load("mongrel/mongrel_cluster.monitrc.erb"), "/tmp/mongrel_cluster_#{application}.monitrc"    
    sudo "install -o root /tmp/mongrel_cluster_#{application}.monitrc /etc/monit/mongrel_cluster_#{application}.monitrc"
  end
    
end