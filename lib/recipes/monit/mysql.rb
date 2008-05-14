namespace :mysql do
  
  namespace :monit do
  
    desc <<-DESC
    Install mysql monit hooks. 
    
    "Source":#{link_to_source(__FILE__)}  
    DESC
    task_arg(:mysql_pid_path, "Path to mysql pid file", :default => "/var/run/mysqld/mysqld.pid")
    task_arg(:mysql_port, "Mysql port", :default => 3306)   
    task_arg(:monit_conf_dir, "Monitrd directory", :default => "/etc/monit")
    task :install do
      put template.load("mysql/mysql.monitrc.erb", binding), "/tmp/mysql.monitrc"    
      run_via "install -o root /tmp/mysql.monitrc #{monit_conf_dir}/mysql.monitrc"
    end      
        
  end
  
end