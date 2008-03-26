namespace :monit do
  
  desc <<-DESC
  Restart (HUP) monit process.
  
  HUP's the process from the pid file, if it exists.
  
  <dl>
  <dt>monit_pid_path</dt>
  <dd>Path to monit pid file</dd>
  <dd class="default">Defaults to @/var/run/monit.pid@</dd>
  </dl>
  DESC
  task :restart do    
    fetch_or_default(:monit_pid_path, "/var/run/monit.pid")
    
    run_via %{sh -c "[ ! -e '#{monit_pid_path}' ] || kill -HUP `cat #{monit_pid_path}`"}
    
  end
  
  desc <<-DESC
  Unmonitor all.
  
  <dl>
  <dt>monit_bin_path</dt>
  <dd>Path to monit bin.</dd>
  <dd>Defaults to @monit@</dd>
  </dl>
  DESC
  task :unmonitor_all do
    fetch_or_default(:monit_bin_path, "monit")
    
    run_via "#{monit_bin_path} unmonitor all"
  end
  
  desc <<-DESC
  Monitor all.
  
  <dl>
  <dt>monit_bin_path</dt>
  <dd>Path to monit bin.</dd>
  <dd>Defaults to @monit@</dd>
  </dl>
  DESC
  task :monitor_all do
    fetch_or_default(:monit_bin_path, "monit")
    
    run_via "#{monit_bin_path} monitor all"
  end
  
end