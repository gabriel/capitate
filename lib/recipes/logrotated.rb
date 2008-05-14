
namespace :logrotated do
  
  desc <<-DESC
  Create logrotated conf. You probably use this in other recipes and not standalone.
    
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:logrotate_name, "Name of file in /etc/logrotate.d/")
  task_arg(:logrotate_log_path, "Path to log file. Can include wildcards, like /var/log/foo_*.log.")
  task_arg(:logrotate_options, <<-EOS)
  Log rotate options
  
  * :rotate (Number of times to rotate before discarding)
  * :size (Rotate when file hits this size)
  * :daily, :weekly, :monthly (How often to perform rotate)
  * :missingok
  * :compress
  * :delaycompress
  * :notifempty
  * :copytruncate
  
  See man page for all the options.
  
  <pre>
  <code class="ruby">
  set :logrotate_options, [ { :rotate => 7, :size => 10MB }, 
      :daily, :missingok, :compress, :delaycompress, :notifempty, :copytruncate ]
  </code>
  </pre>
  EOS
  task :install_conf do
    
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
  
  "Source":#{link_to_source(__FILE__)}   
  DESC
  task_arg(:logrotate_bin_path, "Logrotate bin path", :default => "logrotate", :example => "/usr/local/bin/logrotate")
  task_arg(:logrotate_conf_path, "Path to logrotate conf", :default => "/etc/logrotate.conf")
  task :force do 
    run_via "#{logrotate_bin_path} -f #{logrotate_conf_path}"    
  end
  
end