# Mysql recipes
namespace :mysql do
  
  desc "Install mysql monit hooks"
  task :install_monit do
    
    # Settings 
    mysql_pid_path = profile.get_or_default(:mysql_pid_path, "/var/run/mysqld/mysqld.pid")
    db_port = profile.get_or_default(:db_port, 3306)    
    
    put template.load("mysql/mysql.monitrc.erb", binding), "/tmp/mysql.monitrc"    
    sudo "install -o root /tmp/mysql.monitrc /etc/monit/mysql.monitrc"
  end
  
  desc "Create database user, and database with appropriate permissions"
  task :setup do    
    
    # Settings
    db_name = profile.get(:db_name)
    db_user = profile.get(:db_user)
    db_pass = profile.get(:db_pass) 
    web_host = profile.get(:web_host)
    db_host = profile.get(:db_host)
    mysql_admin_password = profile.get_or_default(:mysql_admin_password, 
      Proc.new { Capistrano::CLI.ui.ask('Mysql admin password: ') })
    
    # Add localhost to grant locations
    locations_for_grant = [ "localhost", web_host, db_host ]
    
    put template.load("mysql/install_db.sql.erb", binding), "/tmp/install_db_#{application}.sql"    
    run "mysql -u root -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
