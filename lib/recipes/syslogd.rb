namespace :syslogd do
  
  desc <<-DESC  
  Add entry to syslog for application.
  
  *syslog_program_name*: syslog program name. What you used for <tt>SyslogLogger.new("program_name_here")</tt>\n  
  *syslog_log_path*: Path to log.\n
  *syslog_conf_path*: Path to syslog conf. _Defaults to <tt>/etc/syslog.conf</tt>_\n
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :setup_conf do 
    
    fetch(:syslog_program_name)
    fetch(:syslog_log_path)
    fetch_or_default(:syslog_conf_path, "/etc/syslog.conf")
        
    utils.append_to(syslog_conf_path, <<-DATA, "^!#{syslog_program_name}")      
              
      # Entry for #{syslog_program_name}
      !#{syslog_program_name}
      *.* #{syslog_log_path}          
    DATA
  end
  
  desc <<-DESC  
  Add entry to newsyslog for application. See newsyslog man page for details.
  
  Adds entry like:
  
  <pre>
  /var/log/my_app.log   640  7     *    @T00  Z
  </pre>
  
  *syslog_log_path*: Path to log. _Defaults to <tt>/var/log/[syslog_program_name].log</tt>_\n
  *newsyslog_conf_path*: Path to newsyslog conf.\n
  *newsyslog_mode*: File mode (to create log with). _Defaults to _\n
  *newsyslog_count*: Number of files to keep. _Defaults to 7_\n
  *newsyslog_size*: Max size. _Defaults to *_\n
  *newsyslog_when*: When to rotate. _Defaults to @T00_\n
  *newsyslog_zb*: Whether to gzip or tarball. _Defaults to Z_\n
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :setup_newsyslog_conf do
    
    fetch(:syslog_log_path)
    fetch_or_default(:newsyslog_conf_path, "/etc/newsyslog.conf")
    
    fetch_or_default(:newsyslog_mode, "640")
    fetch_or_default(:newsyslog_count, "7")
    fetch_or_default(:newsyslog_size, "*")
    fetch_or_default(:newsyslog_when, "@T00")
    fetch_or_default(:newsyslog_zb, "Z")
            
    entry = "#{syslog_log_path} \t#{newsyslog_mode} \t#{newsyslog_count} \t#{newsyslog_size} \t#{newsyslog_when} \t#{newsyslog_zb}"
    
    utils.append_to(newsyslog_conf_path, entry, "^#{syslog_log_path}")    
  end
  
end