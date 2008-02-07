# Mysql recipes
namespace :mysql do
  
  desc "Install mysql"
  task :install do    
    script.install("mysql/install.sh.erb")
  end
  
  desc "Install mysql monit hooks"
  task :install_monit do
    put template.load("mysql/mysql.monitrc.erb", binding), "/tmp/mysql.monitrc"    
    sudo "install -o root /tmp/mysql.monitrc /etc/monit/mysql.monitrc"
  end
  
  desc "Create database user, and database with appropriate permissions"
  task :setup do    
    # Add localhost to grant locations
    locations_for_grant = [ "localhost", web_host ]
    
    put template.load("mysql/install_db.sql.erb", binding), "/tmp/install_db_#{application}.sql"    
    run "mysql -u root -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
