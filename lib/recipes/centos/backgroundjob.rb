namespace :backgroundjob do
  
  namespace :centos do
    
    desc <<-DESC
    Setup backgroundjob for application.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:backgroundjob_bin_path, "Path to backgroundjob", 
      :default => Proc.new{"#{current_path}/script/bj run --forever --rails_env=production --rails_root=#{current_path} --redirect=#{backgroundjob_log_path} --log=#{backgroundjob_log_path} --pidfile=#{backgroundjob_pid_path} --daemon"},
      :default_desc => "\#{current_path}/script/bj run --forever --rails_env=production --rails_root=\#{current_path} --redirect=\#{backgroundjob_log_path} --log=\#{backgroundjob_log_path} --pidfile=\#{backgroundjob_pid_path} --daemon")
    task_arg(:backgroundjob_pid_path, "Path to backgroundjob pid file", :default => Proc.new{"#{shared_path}/pids/bj.pid"}, :default_desc => "\#{shared_path}/pids/bj.pid")
    task_arg(:backgroundjob_log_path, "Path to backgroundjob log file", :default => Proc.new{"#{shared_path}/log/bj.log"}, :default_desc => "\#{shared_path}/log/bj.log")    
    task :setup do       
      
      # Install initscript      
      utils.install_template("backgroundjob/backgroundjob.initd.centos.erb", "/etc/init.d/backgroundjob_#{application}")

      # Enable service
      run_via "/sbin/chkconfig --level 345 backgroundjob_#{application} on"    
      
    end
    
  end
  
end