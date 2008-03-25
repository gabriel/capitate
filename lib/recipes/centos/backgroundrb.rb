namespace :backgroundrb do
  
  namespace :centos do
    
    desc <<-DESC
    Setup backgroundrb for application.
    
    *backgroundrb_bin_path*: Path to start. _Defaults to @{current_path}/script/backgroundrb start@_\n
    *backgroundrb_pid_path*: Path to backgroundrb pid file. _Defaults to @{shared_path}/pids/backgroundrb.pid@_\n
    DESC
    task :setup do       
      
      # Settings
      fetch_or_default(:backgroundrb_bin_path, "#{current_path}/script/backgroundrb -e production")
      fetch_or_default(:backgroundrb_pid_path, "#{shared_path}/pids/backgroundrb.pid")

      # Install initscript      
      utils.install_template("backgroundrb/backgroundrb.initd.centos.erb", "/etc/init.d/backgroundrb_#{application}")

      # Enable service
      run_via "/sbin/chkconfig --level 345 backgroundrb_#{application} on"    
      
    end
    
  end
  
end