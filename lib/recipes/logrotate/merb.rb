namespace :merb do
  
  namespace :logrotate do
    desc <<-DESC
    Install logrotated conf for merb.
  
    <dl>
    <dt>merb_logrotate_path</dt>
    <dd>Merb logrotate path</dd>
    <dd class="default">Defaults to @\#{shared_path}/log/merb_*.log@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}    
    DESC
    task :install do
      fetch_or_default(:merb_logrotate_path, "#{shared_path}/log/merb_*.log")
    
      set :logrotate_name, "merb_#{application}"
      set :logrotate_log_path, merb_logrotate_path
      set :logrotate_options, [ { :rotate => 7 }, :daily, :missingok, :notifempty, :copytruncate ]
    
      logrotated.install_conf      
    end
  end
  
end