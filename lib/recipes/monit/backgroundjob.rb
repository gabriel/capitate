namespace :backgroundjob do
  
  namespace :monit do
  
    desc <<-DESC
    Setup backgroundjob (for application) monitrc.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :setup do
    
      # Settings
      fetch_or_default(:backgroundjob_pid_path, "#{shared_path}/pids/bj.pid")
      fetch_or_default(:monit_conf_dir, "/etc/monit")
    
      utils.install_template("backgroundjob/backgroundjob.monitrc.erb", "#{monit_conf_dir}/backgroundjob.monitrc")
    end
    
    desc "Restart backgroundrb (for application)"
    task :restart do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} restart backgroundjob_#{application}"
    end
    
    desc "Start backgroundrb (for application)"
    task :start do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} start backgroundjob_#{application}" 
    end
    
    desc "Stop backgroundrb (for application)"
    task :stop do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} stop backgroundjob_#{application}"
    end
  end
  
end