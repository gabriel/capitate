namespace :backgroundjob do
  
  namespace :logrotate do
    
    desc <<-DESC
    Install logrotated conf for backgroundjob.
  
    <dl>
    <dt>backgroundjob_logrotate_path<dt>
    <dd>Backgroundjob logrotate paths.</dd>
    <dd class="default">Defaults to @\#{shared_path}/log/bj*.log@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}    
    DESC
    task :install do
      fetch_or_default(:backgroundjob_logrotate_path, "#{shared_path}/log/bj*.log")
    
      set :logrotate_name, "backgroundjob_#{application}"
      set :logrotate_log_path, backgroundjob_logrotate_path
      set :logrotate_options, [ { :rotate => 2 }, :weekly, :missingok, :notifempty, :copytruncate ]
    
      logrotated.install_conf      
    end
  end
  
end