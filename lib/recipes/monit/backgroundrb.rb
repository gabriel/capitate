namespace :backgroundrb do
  
  namespace :monit do
  
    desc <<-DESC
    Generate and install backgroundrb (for application) monitrc.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :install do
    
      # Settings
      fetch_or_default(:backgroundrb_port, 11006)
      fetch_or_default(:backgroundrb_pid_path, "#{shared_path}/pids/backgroundrb.pid")
      fetch_or_default(:monit_conf_dir, "/etc/monit")
    
      utils.install_template("backgroundrb/backgroundrb.monitrc.erb", "#{monit_conf_dir}/backgroundrb.monitrc")
    end
    
    desc "Restart backgroundrb (for application)"
    task :restart do
      sudo "/sbin/service monit restart backgroundrb_#{application}"
    end
    
  end
  
end