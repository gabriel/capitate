# Mysql recipes
namespace :mysql do
  
  desc <<-DESC
  Create database, database user, and set grant permissions.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:db_name, "Database name (application)")
  task_arg(:db_user, "Database user (application)")
  task_arg(:db_pass, "Database password (application)")
  task_arg(:mysql_admin_user, "Mysql admin user", :default => "root")
  task_arg(:mysql_admin_password, "Mysql admin password", 
    :default => Proc.new { prompt.password('Mysql admin password: ') }, 
    :example => "prompt.password('Mysql admin password: ')")
    
  task_arg(:mysql_grant_priv_type, "Grant privilege types", :default => "ALL")
  task_arg(:mysql_grant_locations, "Grant locations", :default => ["localhost"])
  task :setup do    
    sql = template.load("mysql/install_db.sql.erb")       
    
    logger.trace "Running sql:\n#{sql}\n"
        
    put sql, "/tmp/install_db_#{application}.sql"        
    run "mysql -u #{mysql_admin_user} -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
    utils.rm("/tmp/install_db_#{application}.sql")
  end
  
  desc <<-DESC
  Create my.cnf based on template.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:my_cnf_template, "Path to my.cnf template", :default => "mysql/my.cnf.innodb_1024.erb")      
  task_arg(:db_socket, "Path to mysql .sock", :default => "/var/lib/mysql/mysql.sock")
  task_arg(:db_port, "Mysql port", :default => 3306)
  task :install_my_cnf do      
    utils.install_template(my_cnf_template, "/etc/my.cnf")    
  end
  
  
end
