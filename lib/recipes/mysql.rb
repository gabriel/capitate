# Mysql recipes
namespace :mysql do
  
  desc <<-DESC
  Create database, database user, and set grant permissions.
  
  <dl>
  <dt>db_name</dt>
  <dd>Database name (application).</dd>
  
  <dt>db_user</dt>
  <dd>Database user (application).</dd>
  
  <dt>db_pass</dt>
  <dd>Database password (application).</dd>
  
  <dt>mysql_grant_locations</dt>
  <dd>Grant locations. </dd>
  <dd>Defaults to @[ "localhost" ]@</dd>
  
  <dt>mysql_grant_priv_type</dt>
  <dd>Grant privilege types.</dd>
  <dd>Defaults to @ALL@</dd>
  
  <dt>mysql_admin_user</dt>
  <dd>Mysql admin user.</dd>
  <dd>Defaults to password prompt.</dd>
  
  <dt>mysql_admin_password</dt>
  <dd>Mysql admin password.</dd>
  <dd>Defaults to password prompt.</dd>
  </dl>
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :setup do    
    
    # Settings
    fetch(:db_name)
    fetch(:db_user)
    fetch(:db_pass)
    fetch_or_default(:mysql_admin_user, "root")
    fetch_or_default(:mysql_admin_password, prompt.password('Mysql admin password: '))
    fetch_or_default(:mysql_grant_priv_type, "ALL")
    fetch_or_default(:mysql_grant_locations, [ "localhost" ])
    
    sql = template.load("mysql/install_db.sql.erb")       
    
    logger.trace "Running sql:\n#{sql}\n"
        
    put sql, "/tmp/install_db_#{application}.sql"        
    run "mysql -u #{mysql_admin_user} -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
    utils.rm("/tmp/install_db_#{application}.sql")
  end
  
  desc <<-DESC
  Create my.cnf based on template.
  
  <dl>
  <dt>my_cnf_template</dt>
  <dd>Path to my.cnf template</dd>
  
  <dt>db_socket</dt>
  <dd>Path to mysql .sock</dd>
  <dd class="default">Defaults to @"/var/lib/mysql/mysql.sock"@</dd>
  
  <dt>db_port</dt>
  <dd>Mysql port</dd>
  <dd class="default">Defaults to @3306@</dd>
  </dl>
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :install_my_cnf do      
    fetch_or_default(:my_cnf_template, "mysql/my.cnf.innodb_1024.erb")      
    fetch_or_default(:db_socket, "/var/lib/mysql/mysql.sock")
    fetch_or_default(:db_port, 3306)
    
    utils.install_template(my_cnf_template, "/etc/my.cnf")    
  end
  
  
end
