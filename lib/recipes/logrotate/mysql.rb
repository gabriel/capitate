namespace :mysql do
  
  namespace :logrotate do
    
    desc <<-DESC
    Install logrotated conf for nginx.
    
    <dl>
    <dt>mysql_logrotate_path</dt>
    <dd>Mysql logrotate path</dd>
    <dd class="default">Defaults to @"/var/lib/mysql/localhost-slow.log"@</dd>    
    </dl>
    "Source":#{link_to_source(__FILE__)}    
    DESC
    task :install, :roles => :db do
      fetch_or_default(:mysql_logrotate_path, "/var/lib/mysql/localhost-slow.log")
      
      set :logrotate_name, "mysql"
      set :logrotate_log_path, mysql_logrotate_path
      set :logrotate_options, [ { :rotate => 7, :size => "10M" }, :daily, :missingok, :notifempty, :copytruncate ]
      
      logrotated.install_conf      
    end    
        
  end
end