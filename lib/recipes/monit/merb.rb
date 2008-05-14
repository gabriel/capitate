
namespace :merb do

  namespace :monit do
    
    desc <<-DESC
    Create monit configuration for merb.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:merb_nodes, "Number of nodes in merb cluster")
    task_arg(:merb_port, "Starting port")
    task_arg(:monit_conf_dir, "Monit config directory", :default => "/etc/monit")
    task_arg(:merb_pid_dir, "Merb pid directory", :default => Proc.new {"#{shared_path}/pids"}, :default_desc => "\#{shared_path}/pids")
    task_arg(:merb_monitrc_template, "Merb monitrc template", :default => "merb/merb.monitrc.erb")
    task :setup do
  
      processes = []
      ports = (0...merb_nodes).collect { |i| merb_port + i }
      ports.each do |port|
        
        pid_path = "#{merb_pid_dir}/merb.#{port}.pid"
        
        start = "/etc/init.d/#{merb_initscript_name} start_only #{port}"
        stop = "/etc/init.d/#{merb_initscript_name} stop_only #{port}"
        
        processes << { :port => port, :start => start, :stop => stop, :pid_path => pid_path }
      end
  
      set :processes, processes
      
      utils.install_template(merb_monitrc_template, "#{monit_conf_dir}/#{merb_application}.monitrc") 
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