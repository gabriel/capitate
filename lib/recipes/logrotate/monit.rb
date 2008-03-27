namespace :monit do
  
  namespace :logrotate do
    
    desc <<-DESC
    Install logrotated conf for monit.
    
    <dl>
    <dt>monit_log_path</dt>
    <dd>Path to monit log</dd>
    <dd class="default">Defaults to @"/var/log/monit.log"@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}    
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