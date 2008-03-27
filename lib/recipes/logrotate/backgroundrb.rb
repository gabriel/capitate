namespace :backgroundrb do
  
  namespace :logrotate do
    
    desc <<-DESC
    Install logrotated conf for backgroundrb.
  
    <dl>
    <dt>backgroundrb_logrotate_path<dt>
    <dd>Backgroundrb logrotate paths.</dd>
    <dd class="default">Defaults to @\#{shared_path}/log/backgroundrb*.log@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}    
    DESC
    task :install do
      fetch_or_default(:backgroundrb_logrotate_path, "#{shared_path}/log/backgroundrb*.log")
    
      set :logrotate_name, "backgroundrb_#{application}"
      set :logrotate_log_path, backgroundrb_logrotate_path
      set :logrotate_options, [ { :rotate => 2 }, :weekly, :missingok, :notifempty, :copytruncate ]
    
      logrotated.install_conf      
    end
  end
  
end