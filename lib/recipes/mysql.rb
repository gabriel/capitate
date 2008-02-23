# Mysql recipes
namespace :mysql do
  
  desc <<-DESC
  Install mysql monit hooks.
  
  *db_port*: Mysql port. _Defaults to 3306_
    
  @set :db_port, 3306@
    
  *mysql_pid_path*: Path to mysql pid file. _Defaults to /var/run/mysqld/mysqld.pid_
    
  @set :mysql_pid_path, "/var/run/mysqld/mysqld.pid"@
    
  *monit_conf_dir*: Destination for monitrc. _Defaults to "/etc/monit"_

  @set :monit_conf_dir, "/etc/monit"@

  DESC
  task :install_monit do
    
    # Settings 
    fetch_or_default(:mysql_pid_path, "/var/run/mysqld/mysqld.pid")
    fetch_or_default(:db_port, 3306)   
    fetch_or_default(:monit_conf_dir, "/etc/monit") 
    
    put template.load("mysql/mysql.monitrc.erb", binding), "/tmp/mysql.monitrc"    
    sudo "install -o root /tmp/mysql.monitrc #{monit_conf_dir}/mysql.monitrc"
  end
  
  desc <<-DESC
  Create database user, and database with appropriate permissions.
  
  *db_name*: Database name (application).    
  
  @set :db_name, "app_db_name"@
  
  *db_user*: Database user (application).    
  
  @set :db_user, "app_db_user"@
    
  *db_pass*: Database password (application).    
  
  @set :db_pass, "the_password"@
    
  *web_host*: Web host to provide access privileges to (if recipe used in context of web app). 
  _Defaults to nil_ (TODO: Support multiple web hosts)
  
  @set :web_host, 10.0.6.100@
    
  *db_host*: Database host (to provide itself with access).    
  
  @set :db_host, 10.0.6.101@
    
  *mysql_admin_password*: Mysql admin password (to use to connect). Defaults to password prompt.
  
  @set :mysql_admin_password, Proc.new { Capistrano::CLI.ui.ask('Mysql admin password: ') })@
    
  DESC
  task :setup do    
    
    # Settings
    fetch(:db_name)
    fetch(:db_user)
    fetch(:db_pass)
    fetch(:db_host)
    fetch_or_default(:mysql_admin_password, Proc.new { Capistrano::CLI.ui.ask('Mysql admin password: ') })
    fetch_or_default(:web_host, nil)
        
    # Add localhost to grant locations
    set :locations_for_grant, [ "localhost", web_host, db_host ].compact
    
    put template.load("mysql/install_db.sql.erb"), "/tmp/install_db_#{application}.sql"    
    run "mysql -u root -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
