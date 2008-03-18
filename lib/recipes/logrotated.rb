
namespace :logrotated do
  
  desc <<-DESC
  Create logrotated conf. You probably use this in other recipes and not standalone.
  
  *logrotate_name*: Name of file in /etc/logrotate.d/\n  
  *logrotate_log_path*: Path to log file. Can include wildcards, like /var/log/foo_*.log.\n
  
  *logrotate_options*:
  - :rotate (Number of times to rotate before discarding)
  - :size (Rotate when file hits this size)
  - :daily, :weekly, :monthly (How often to perform rotate)
  - :missingok
  - :compress
  - :delaycompress
  - :notifempty
  - :copytruncate  
  
  See man page for all the options.
  
  <pre>
  set :logrotate_options, [ { :rotate => 7, :size => 10MB }, 
      :daily, :missingok, :compress, :delaycompress, :notifempty, :copytruncate ]
  </pre>
  
  DESC
  task :install_conf do
    
    fetch(:logrotate_name)
    fetch(:logrotate_log_path)
    fetch(:logrotate_options)
    
    text = []    
    logrotate_options.each do |option|            
      if option.is_a?(Hash)
        option.each do |key, value|
          text << "#{key.to_s} #{value.to_s}"
        end
      else
        text << option.to_s
      end
    end    
    set :logrotate_options_text, "  " + text.join("\n  ")
    
    utils.install_template("logrotated/conf.erb", "/etc/logrotate.d/#{logrotate_name}")    
    
  end
  
  desc <<-DESC
  Force rotate files.
  DESC
  task :force do 
    fetch_or_default(:logrotate_conf_path, "/etc/logrotate.conf")    
    run_via "logrotate -f #{logrotate_conf_path}"    
  end
  
end