namespace :syslogd do
  
  desc <<-DESC  
  Add entry to syslog for application.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:syslog_program_name, "Syslog program name. What you used for @SyslogLogger.new(\"program_name_here\")@")
  task_arg(:syslog_log_path, "Path to log")
  task_arg(:syslog_conf_path, :default => "/etc/syslog.conf")
  task :setup_conf do 
        
    utils.append_to(syslog_conf_path, <<-DATA, "^!#{syslog_program_name}")      
              
      # Entry for #{syslog_program_name}
      !#{syslog_program_name}
      *.* #{syslog_log_path}          
    DATA
  end
  
end