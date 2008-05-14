namespace :backgroundrb do
  
  namespace :centos do
    
    desc <<-DESC
    Setup backgroundrb for application.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:backgroundrb_bin_path, "Path to backgroundrb bin", :default => Proc.new{"#{current_path}/script/backgroundrb -e production start"}, :default_desc => "\#{current_path}/script/backgroundrb -e production start")
    task_arg(:backgroundrb_pid_path, "Path to backgroundrb pid file", :default => Proc.new{"#{shared_path}/pids/backgroundrb.pid"}, :default_desc => "\#{shared_path}/pids/backgroundrb.pid")    
    task :setup do       
      # Install initscript      
      utils.install_template("backgroundrb/backgroundrb.initd.centos.erb", "/etc/init.d/backgroundrb_#{application}")

      # Enable service
      run_via "/sbin/chkconfig --level 345 backgroundrb_#{application} on"    
      
    end
    
  end
  
end