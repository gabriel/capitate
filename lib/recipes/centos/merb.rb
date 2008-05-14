namespace :merb do
  namespace :centos do
    
    desc <<-DESC
    Setup merb.
      
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:merb_nodes, "Number of merb daemons to run")
    task_arg(:merb_port, "Starting port for merb nodes. If there are 3 merb nodes with port 9000, then instances will be at 9000, 9001, and 9002")
    task_arg(:merb_command_path, "The path for merb startup command", :default => "merb")
    task_arg(:merb_pid_path, "Path for merb pids", :default => Proc.new{"#{shared_path}/pids/merb.pid"}, :default_desc => "\#{shared_path}/pids/merb.pid")
    task_arg(:merb_root, "Directory for merb root", :set => :current_path)
    task_arg(:merb_application, "Merb application name", :default => Proc.new{"merb_#{application}"}, :default_desc => "merb_\#{application}")    
    task_arg(:merb_initscript_name, "Initscript name", :default => Proc.new{"merb_#{application}"}, :default_desc => "merb_\#{application}")
    task :setup do 
      utils.install_template("merb/merb.initd.centos.erb", "/etc/init.d/#{merb_initscript_name}")
      run_via "/sbin/chkconfig --level 345 #{merb_initscript_name} on"
    end
    
  end
  
end