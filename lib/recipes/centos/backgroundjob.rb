namespace :backgroundjob do
  
  namespace :centos do
    
    desc <<-DESC
    Setup backgroundjob for application.
    
    <dl>
    <dt>backgroundjob_bin_path</dt>
    <dd>Path to start.
    <dd class="default">Defaults to: 
    <pre>
      \#{current_path}/script/bj --forever --rails_env=production --rails_root=\#{current_path} --redirect \
      --redirect=\#{backgroundjob_log_path} --pidfile=\#{backgroundjob_pid_path} --daemon
    </pre>
    </dd>
    <dt>backgroundjob_pid_path</dt>
    <dd>Path to backgroundjob pid file</dd>
    <dd class="default">Defaults to @\#{shared_path}/pids/bj.pid@</dd>
    
    <dt>backgroundjob_log_path</dt>
    <dd>Path to backgroundjob log file</dd>
    <dd class="default">Defaults to @\#{shared_path}/logs/bj.log@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :setup do       
      # Settings
      fetch_or_default(:backgroundjob_pid_path, "#{shared_path}/pids/bj.pid")
      fetch_or_default(:backgroundjob_log_path, "#{shared_path}/log/bj.log")
      
      default_bin_path = "#{current_path}/script/bj run --forever --rails_env=production --rails_root=#{current_path} \
--redirect=#{backgroundjob_log_path} --pidfile=#{backgroundjob_pid_path} --daemon"
      
      fetch_or_default(:backgroundjob_bin_path, default_bin_path)      

      # Install initscript      
      utils.install_template("backgroundjob/backgroundjob.initd.centos.erb", "/etc/init.d/backgroundjob_#{application}")

      # Enable service
      run_via "/sbin/chkconfig --level 345 backgroundjob_#{application} on"    
      
    end
    
  end
  
end