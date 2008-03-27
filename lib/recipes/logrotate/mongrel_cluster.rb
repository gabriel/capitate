namespace :mongrel do
  
  namespace :cluster do
    
    namespace :logrotate do
      desc <<-DESC
      Install logrotated conf for mongrel cluster.
    
      <dl>
      <dt>mongrel_cluster_logrotate_path</dt>
      <dd>Mongrel cluster logrotate path</dd>
      <dd class="default">Defaults to @\#{shared_path}/log/mongrel_cluster_*.log@</dd>
      </dl>
      "Source":#{link_to_source(__FILE__)}    
      DESC
      task :install do
        fetch_or_default(:mongrel_cluster_logrotate_path, "#{shared_path}/log/mongrel_cluster_*.log")
      
        set :logrotate_name, "mongrel_cluster_#{application}"
        set :logrotate_log_path, mongrel_cluster_logrotate_path
        set :logrotate_options, [ { :rotate => 7 }, :daily, :missingok, :notifempty, :copytruncate ]
      
        logrotated.install_conf      
      end
    end
    
  end
  
end