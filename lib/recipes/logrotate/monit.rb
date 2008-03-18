namespace :monit do
  
  namespace :logrotate do
    
    desc <<-DESC
    Install logrotated conf for monit.
    
    *monit_log_path*: Path to monit log. _Defaults to <tt>/var/log/monit.log</tt>_
    DESC
    task :install do
      
      fetch_or_default(:monit_log_path, "/var/log/monit.log")
      
      set :logrotate_name, "monit"
      set :logrotate_log_path, monit_log_path
      set :logrotate_options, [ { :rotate => 1, :size => "200k" },  :weekly, :missingok, :notifempty, :copytruncate ]
      
      logrotated.install_conf      
    end    
    
  end
  
end