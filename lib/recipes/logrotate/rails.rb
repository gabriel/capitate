namespace :rails do
  
  # Log rotate tasks
  namespace :logrotate do
    desc <<-DESC
    Install logrotated conf for rails.
  
    *rails_logrotate_path*: Rails logrotate path. _Defaults to <tt>{shared_path}/log/production.log</tt>_
    DESC
    task :install do
      fetch_or_default(:rails_logrotate_path, "#{shared_path}/log/production.log")
    
      set :logrotate_name, "rails_#{application}"
      set :logrotate_log_path, rails_logrotate_path
      set :logrotate_options, [ { :rotate => 7, :size => "10M" }, :daily, :missingok, :notifempty, :copytruncate ]
    
      logrotated.install_conf      
    end
  end
  
end