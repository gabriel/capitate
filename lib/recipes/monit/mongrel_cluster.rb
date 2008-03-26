# Create init script
namespace :mongrel do

  namespace :cluster do

    namespace :monit do
      
      desc <<-DESC
      Create monit configuration for mongrel cluster.
      "Source":#{link_to_source(__FILE__)}
      DESC
      task :setup do
    
        # See http://www.igvita.com/2006/11/07/monit-makes-mongrel-play-nice/
    
        # TODO: For depends on memcached setting
        # See http://blog.labratz.net/articles/2007/5/1/monit-for-your-uptime 
    
        # Settings
        fetch(:mongrel_size)
        fetch(:mongrel_port)
        fetch_or_default(:mongrel_application, Proc.new { "mongrel_cluster_#{fetch(:application)}" })
        fetch_or_default(:mongrel_bin_path, "/usr/bin/mongrel_rails")
        fetch_or_default(:mongrel_config_script, nil)
        fetch_or_default(:monit_conf_dir, "/etc/monit")
    
        processes = []
        ports = (0...mongrel_size).collect { |i| mongrel_port + i }
        ports.each do |port|
      
          pid_path = "#{shared_path}/pids/#{mongrel_application}.#{port}.pid"
      
          default_options = [
            [ "-d" ], 
            [ "-e", "production" ],
            [ "-a", "127.0.0.1" ],
            [ "-c", current_path ],
            [ "--user", user ], 
            [ "--group", user ],
            [ "-p", port ], 
            [ "-P", pid_path ],
            [ "-l", "log/#{mongrel_application}.#{port}.log" ]
          ]
      
          default_options << [ "-S", mongrel_config_script ] if mongrel_config_script 
      
          start_options = default_options.collect { |a| a.join(" ") }.join(" ")      
          #start_options = "-d -e production -a 127.0.0.1 -c #{current_path} --user #{user} --group #{user} -p #{port} -P #{pid_path} -l log/mongrel.#{port}.log"
          stop_options = "-p #{port} -P #{pid_path}"
      
          processes << { :port => port, :start_options => start_options, :stop_options => stop_options, :name => mongrel_bin_path, :pid_path => pid_path }
        end
    
        set :processes, processes
    
        put template.load("mongrel/mongrel_cluster.monitrc.erb"), "/tmp/#{mongrel_application}.monitrc"    
        sudo "install -o root /tmp/#{mongrel_application}.monitrc #{monit_conf_dir}/#{mongrel_application}.monitrc"
      end
      
      desc "Restart mongrel cluster (for application)"
      task :restart do       
        fetch_or_default(:monit_bin_path, "monit") 
        fetch_or_default(:mongrel_application, Proc.new { "mongrel_cluster_#{fetch(:application)}" })        
        sudo "#{monit_bin_path} -g #{mongrel_application} restart all"
      end
      
      desc "Start mongrel cluster (for application)"
      task :start do        
        fetch_or_default(:monit_bin_path, "monit")
        fetch_or_default(:mongrel_application, Proc.new { "mongrel_cluster_#{fetch(:application)}" })        
        sudo "#{monit_bin_path} -g #{mongrel_application} start all" 
      end
      
      desc "Stop mongrel cluster (for application)"
      task :stop do        
        fetch_or_default(:monit_bin_path, "monit")
        fetch_or_default(:mongrel_application, Proc.new { "mongrel_cluster_#{fetch(:application)}" })        
        sudo "#{monit_bin_path} -g #{mongrel_application} stop all" 
      end
      
    end
    
  end
    
end