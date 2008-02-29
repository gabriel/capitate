namespace :monit do
  
  desc <<-DESC
  Restart (HUP) monit process.
  
  HUP's the process from the pid file, if it exists.
  
  *monit_pid_path*: Path to monit pid file. _Defaults to <tt>/var/run/monit.pid</tt>_
  DESC
  task :restart do    
    fetch_or_default(:monit_pid_path, "/var/run/monit.pid")
    
    run_via %{sh -c "[ ! -e '#{monit_pid_path}' ] || kill -HUP `cat #{monit_pid_path}`"}
    
  end
  
  desc <<-DESC
  Unmonitor all.
  
  *monit_bin_path*: Path to monit bin. _Defaults to <tt>monit</tt>_
  DESC
  task :unmonitor_all do
    fetch_or_default(:monit_bin_path, "monit")
    
    run_via "#{monit_bin_path} unmonitor all"
  end
  
  desc <<-DESC
  Monitor all.
  
  *monit_bin_path*: Path to monit bin. _Defaults to <tt>monit</tt>_
  DESC
  task :monitor_all do
    fetch_or_default(:monit_bin_path, "monit")
    
    run_via "#{monit_bin_path} monitor all"
  end
  
end