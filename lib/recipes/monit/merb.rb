
namespace :merb do

    namespace :monit do
    
    desc <<-DESC
    Create monit configuration for merb.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :setup do
  
      # Settings
      fetch(:merb_nodes)
      fetch(:merb_port)
      fetch_or_default(:merb_application, "merb_#{application}")
      fetch_or_default(:merb_initscript_name, "merb_#{application}")
      fetch_or_default(:monit_conf_dir, "/etc/monit")
  
      fetch_or_default(:merb_pid_dir, "#{shared_path}/pids")
  
      processes = []
      ports = (0...merb_nodes).collect { |i| merb_port + i }
      ports.each do |port|
        
        pid_path = "#{merb_pid_dir}/#{merb_application}.#{port}.pid"
        
        start = "/etc/init.d/#{merb_initscript_name} start_only #{port}"
        stop = "/etc/init.d/#{merb_initscript_name} stop_only #{port}"
        
        processes << { :port => port, :start => start, :stop => stop, :pid_path => pid_path }
      end
  
      set :processes, processes
  
      put template.load("merb/merb.monitrc.erb"), "/tmp/#{merb_application}.monitrc"    
      sudo "install -o root /tmp/#{merb_application}.monitrc #{monit_conf_dir}/#{merb_application}.monitrc"
    end
    
    desc "Restart merb (for application)"
    task :restart do       
      fetch_or_default(:monit_bin_path, "monit") 
      fetch_or_default(:merb_application, "merb_#{application}")
      sudo "#{monit_bin_path} -g #{merb_application} restart all"
    end
    
    desc "Start merb (for application)"
    task :start do        
      fetch_or_default(:monit_bin_path, "monit") 
      fetch_or_default(:merb_application, "merb_#{application}")
      sudo "#{monit_bin_path} -g #{merb_application} start all" 
    end
    
    desc "Stop merb (for application)"
    task :stop do        
      fetch_or_default(:monit_bin_path, "monit") 
      fetch_or_default(:merb_application, "merb_#{application}")  
      sudo "#{monit_bin_path} -g #{merb_application} stop all" 
    end
    
  end
    
end