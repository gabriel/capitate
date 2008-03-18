namespace :sphinx do 
  
  # Log rotate tasks
  namespace :logrotate do
    desc <<-DESC
    Install logrotated conf for sphinx.
  
    *sphinx_logrotate_path*: Sphinx logrotate paths. _Defaults to <tt>{shared_path}/log/query.log {shared_path}/log/searchd.log</tt>_
    DESC
    task :install do
      fetch_or_default(:sphinx_logrotate_path, "#{shared_path}/log/query.log #{shared_path}/log/searchd.log")
    
      set :logrotate_name, "sphinx_#{application}"
      set :logrotate_log_path, sphinx_logrotate_path
      set :logrotate_options, [ { :rotate => 7 }, :daily, :missingok, :notifempty, :copytruncate ]
    
      logrotated.install_conf      
    end
  end
  
end