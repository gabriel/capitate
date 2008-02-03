# Mysql recipes
namespace :mysql do
  
  after "mysql:install", "mysql:install_monit"
  
  desc "Install mysql"
  task :install do    
    
    set :mysql_admin_password, Proc.new { Capistrano::CLI.ui.ask('Mysql admin password (to set): ') }
    
    package_install([ "mysql", "mysql-devel", "mysql-server" ])
    script_install("mysql/install.sh.erb")
  end
  
  desc "Create monit configuration for mysql"
  task :install_monit do
    
    pid_path = "/var/run/mysqld/mysqld.pid"
    db_port = config.db_port
    
    put load_template("mysql/mysql.monitrc.erb", binding), "/tmp/mysql.monitrc"    
    
    sudo "install -o root /tmp/mysql.monitrc /etc/monit/mysql.monitrc"    
  end
  
  desc "Create database user, and database with appropriate permissions"
  task :setup do
    
    set :mysql_admin_password, Proc.new { Capistrano::CLI.ui.ask('Mysql admin password: ') }
    
    # Locations can access from
    locations_for_grant = [ "localhost", web_host ]
    
    put load_template("mysql/install_db.sql.erb", binding), "/tmp/install_db_#{application}.sql"    
    
    run "mysql -u root -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
