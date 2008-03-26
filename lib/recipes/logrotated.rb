
namespace :logrotated do
  
  desc <<-DESC
  Create logrotated conf. You probably use this in other recipes and not standalone.
  
  <dl>
  <dt>logrotate_name</dt>
  <dd>Name of file in /etc/logrotate.d/</dd>
  
  <dt>logrotate_log_path<dt>
  <dd>Path to log file. Can include wildcards, like /var/log/foo_*.log.</dd>
  
  <dt>logrotate_options</dt>
  <dd>:rotate (Number of times to rotate before discarding)</dd>
  <dd>:size (Rotate when file hits this size)</dd>
  <dd>:daily, :weekly, :monthly (How often to perform rotate)</dd>
  <dd>:missingok</dd>
  <dd>:compress</dd>
  <dd>:delaycompress</dd>
  <dd>:notifempty</dd>
  <dd>:copytruncate</dd>
  
  See man page for all the options.
  
  <pre>
  <code class="ruby">
  set :logrotate_options, [ { :rotate => 7, :size => 10MB }, 
      :daily, :missingok, :compress, :delaycompress, :notifempty, :copytruncate ]
  </code>
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
        
    fetch_or_default(:logrotate_prefix, "")
    fetch_or_default(:logrotate_conf_path, "/etc/logrotate.conf")    
    
    command = "logrotate"
    command = "#{logrotate_prefix}/logrotate" unless logrotate_prefix.blank?
    
    run_via "#{command} -f #{logrotate_conf_path}"    
  end
  
end