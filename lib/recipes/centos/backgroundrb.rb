namespace :backgroundrb do
  
  namespace :centos do
    
    desc <<-DESC
    Setup backgroundrb for application.
    
    <dl>
    <dt>backgroundrb_bin_path</dt>
    <dd>Path to start.
    <dd class="default">Defaults to @\#{current_path}/script/backgroundrb -e production start@</dd>
    <dt>backgroundrb_pid_path</dt>
    <dd>Path to backgroundrb pid file</dd>
    <dd class="default">Defaults to @\#{shared_path}/pids/backgroundrb.pid@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :setup do       
      
      # Settings
      fetch_or_default(:backgroundrb_bin_path, "#{current_path}/script/backgroundrb -e production start")
      fetch_or_default(:backgroundrb_pid_path, "#{shared_path}/pids/backgroundrb.pid")

      # Install initscript      
      utils.install_template("backgroundrb/backgroundrb.initd.centos.erb", "/etc/init.d/backgroundrb_#{application}")

      # Enable service
      run_via "/sbin/chkconfig --level 345 backgroundrb_#{application} on"    
      
    end
    
  end
  
end