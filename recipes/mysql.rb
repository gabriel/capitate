# Mysql recipes
namespace :mysql do
  
  desc "Create database user, and database with appropriate permissions"
  task :setup do
    # Locations can access from
    locations_for_grant = [ "localhost", web_server ]
    
    put load_template("mysql/install_db.sql.erb", binding), "/tmp/install_db_#{application}.sql"    
    
    run "mysql -u #{mysql_admin_user} -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
