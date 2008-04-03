namespace :mysql do
  
  namespace :monit do
  
    desc <<-DESC
    Install mysql monit hooks. 
    
    <dl>
    <dt>mysql_pid_path</dt>
    <dd>Path to mysql pid file</dd>

    <dt>db_port</dt>
    <dd>Mysql port</dd>
    <dd class="default">Defaults to @3306@</dd>
    
    <dt>monit_conf_dir</dt>
    <dd>Monitrd directory.</dd>
    <dd class="default">Defaults to @"/etc/monit"@</dd>
    </dl>    
    
    "Source":#{link_to_source(__FILE__)}  
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