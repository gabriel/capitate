# Mysql recipes
namespace :mysql do
  
  desc "Install mysql"
  task :install do    
    set :mysql_admin_password, Capistrano::CLI.ui.ask('Mysql admin password (to set): ')
    
    yum_install([ "mysql", "mysql-devel", "mysql-server" ])
    
    install_script("mysql/install.sh.erb")
    
  end
  
  desc "Create database user, and database with appropriate permissions"
  task :setup do
    # Locations can access from
    locations_for_grant = [ "localhost", web_server ]
    
    put load_template("mysql/install_db.sql.erb", binding), "/tmp/install_db_#{application}.sql"    
    
    run "mysql -u #{mysql_admin_user} -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
