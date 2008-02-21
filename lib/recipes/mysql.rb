# Mysql recipes
namespace :mysql do
  
  desc "Install mysql monit hooks"
  task :install_monit do
    
    # Settings 
    fetch(:mysql_pid_path, "/var/run/mysqld/mysqld.pid")
    fetch(:db_port, 3306)    
    
    put template.load("mysql/mysql.monitrc.erb", binding), "/tmp/mysql.monitrc"    
    sudo "install -o root /tmp/mysql.monitrc /etc/monit/mysql.monitrc"
  end
  
  desc "Create database user, and database with appropriate permissions"
  task :setup do    
    
    # Settings
    fetch(:db_name)
    fetch(:db_user)
    fetch(:db_pass)
    fetch(:db_host)
    fetch(:mysql_admin_password, Proc.new { Capistrano::CLI.ui.ask('Mysql admin password: ') })
    fetch(:web_host, nil)
        
    # Add localhost to grant locations
    set :locations_for_grant, [ "localhost", web_host, db_host ].compact
    
    put template.load("mysql/install_db.sql.erb"), "/tmp/install_db_#{application}.sql"    
    run "mysql -u root -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
