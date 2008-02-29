# Create init script
namespace :mongrel do

  namespace :cluster do

    namespace :monit do
      
      desc <<-DESC
      Create monit configuration for mongrel cluster.
  
      *mongrel_application*: Name of application (monit group). _Defaults to <tt>"mongrel_cluster_\#{fetch(:application)}"</tt>_
      *mongrel_size*: Number of mongrels.\n  
      @set :mongrel_size, 3@\n
      *mongrel_port*: Starting port for mongrels. If there are 3 mongrels with port 9000, then instances 
      will be at 9000, 9001, and 9002\n    
      @set :mongrel_port, 9000@\n    
      *mongrel_config_script*: Config script to load with mongrel. _Defaults to nil_\n  
      @set :mongrel_config_script, "config/mongrel_handler.rb"@\n    
      *monit_conf_dir*: Destination for monitrc. _Defaults to "/etc/monit"_\n  
      @set :monit_conf_dir, "/etc/monit"@\n  
      DESC
      task :setup do
    
        # See http://www.igvita.com/2006/11/07/monit-makes-mongrel-play-nice/
    
        # TODO: For depends on memcached setting
        # See http://blog.labratz.net/articles/2007/5/1/monit-for-your-uptime 
    
        # Settings
        fetch(:mongrel_size)
        fetch(:mongrel_port)
        fetch_or_default(:mongrel_application, Proc.new { "mongrel_cluster_#{fetch(:application)}" })
        fetch_or_default(:mongrel_config_script, nil)
        fetch_or_default(:monit_conf_dir, "/etc/monit")
    
        processes = []
        ports = (0...mongrel_size).collect { |i| mongrel_port + i }
        ports.each do |port|
      
          pid_path = "#{shared_path}/pids/mongrel.#{port}.pid"
      
          default_options = [
            [ "-d" ], 
            [ "-e", "production" ],
            [ "-a", "127.0.0.1" ],
            [ "-c", current_path ],
            [ "--user", user ], 
            [ "--group", user ],
            [ "-p", port ], 
            [ "-P", pid_path ],
            [ "-l", "log/mongrel.#{port}.log" ]
          ]
      
          default_options << [ "-S", mongrel_config_script ] if mongrel_config_script 
      
          start_options = default_options.collect { |a| a.join(" ") }.join(" ")      
          #start_options = "-d -e production -a 127.0.0.1 -c #{current_path} --user #{user} --group #{user} -p #{port} -P #{pid_path} -l log/mongrel.#{port}.log"
          stop_options = "-p #{port} -P #{pid_path}"
      
          processes << { :port => port, :start_options => start_options, :stop_options => stop_options, :name => "/usr/bin/mongrel_rails", :pid_path => pid_path }
        end
    
        set :processes, processes
    
        put template.load("mongrel/mongrel_cluster.monitrc.erb"), "/tmp/#{mongrel_application}.monitrc"    
        sudo "install -o root /tmp/#{mongrel_application}.monitrc #{monit_conf_dir}/#{mongrel_application}.monitrc"
      end
      
    end
    
  end
    
end