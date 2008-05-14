namespace :monit do
  
  desc <<-DESC
  Restart (HUP) monit process.
  
  HUP's the process from the pid file, if it exists.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:monit_pid_path, "Path to monit pid file", :default => "/var/run/monit.pid")
  task :restart do    
    run_via %{sh -c "[ ! -e '#{monit_pid_path}' ] || kill -HUP `cat #{monit_pid_path}`"}    
  end
  
  desc <<-DESC
  Unmonitor all.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:monit_bin_path, "Path to monit bin.", :default => "monit")
  task :unmonitor_all do
    run_via "#{monit_bin_path} unmonitor all"
  end
  
  desc <<-DESC
  Monitor all.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:monit_bin_path, "Path to monit bin.", :default => "monit")
  task :monitor_all do
    run_via "#{monit_bin_path} monitor all"
  end
  
end