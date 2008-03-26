namespace :mysql do
  
  namespace :monit do
  
    desc <<-DESC
    Install mysql monit hooks. "Source":#{link_to_source(__FILE__)}  
    DESC
    task :install do
    
      # Settings 
      fetch_or_default(:mysql_pid_path, "/var/run/mysqld/mysqld.pid")
      fetch_or_default(:mysql_port, 3306)   
      fetch_or_default(:monit_conf_dir, "/etc/monit") 
    
      put template.load("mysql/mysql.monitrc.erb", binding), "/tmp/mysql.monitrc"    
      run_via "install -o root /tmp/mysql.monitrc #{monit_conf_dir}/mysql.monitrc"
    end
    
  end
  
end