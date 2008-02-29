# Mysql recipes
namespace :mysql do
  
  namespace :monit do
  
    desc <<-DESC
    Install mysql monit hooks.
  
    *db_port*: Mysql port. _Defaults to 3306_\n
    *mysql_pid_path*: Path to mysql pid file. _Defaults to /var/run/mysqld/mysqld.pid_\n
    @set :mysql_pid_path, "/var/run/mysqld/mysqld.pid"@\n
    *monit_conf_dir*: Destination for monitrc. _Defaults to "/etc/monit"_\n
    @set :monit_conf_dir, "/etc/monit"@\n
    DESC
    task :install do
    
      # Settings 
      fetch_or_default(:mysql_pid_path, "/var/run/mysqld/mysqld.pid")
      fetch_or_default(:db_port, 3306)   
      fetch_or_default(:monit_conf_dir, "/etc/monit") 
    
      put template.load("mysql/mysql.monitrc.erb", binding), "/tmp/mysql.monitrc"    
      run_via "install -o root /tmp/mysql.monitrc #{monit_conf_dir}/mysql.monitrc"
    end
    
  end
  
  desc <<-DESC
  Create database, database user, and set grant permissions.
  
  *db_name*: Database name (application).\n
  *db_user*: Database user (application).\n    
  *db_pass*: Database password (application).\n
  *mysql_grant_locations*: Grant locations. _Defaults to localhost_\n
  @set :mysql_grant_locations, [ "localhost", "192.168.1.111" ]@\n
  *mysql_grant_priv_type*: Grant privilege types. _Defaults to ALL_\n
  @set :mysql_grant_priv_type, "ALL"@\n
  *mysql_admin_password*: Mysql admin password (to use to connect). Defaults to password prompt.\n
  @set :mysql_admin_password, prompt.password('Mysql admin password: '))@    
  DESC
  task :setup do    
    
    # Settings
    fetch(:db_name)
    fetch(:db_user)
    fetch(:db_pass)
    fetch_or_default(:mysql_admin_password, prompt.password('Mysql admin password: '))
    fetch_or_default(:mysql_grant_priv_type, "ALL")
    
    # Set grant locations to all servers in roles: :search, :db, :app
    unless exists?(:mysql_grant_locations) 
      mysql_grant_locations = [ "localhost" ]
      role_names = [ :search, :db, :app ]
      role_names.each do |role_name| 
        roles[role_name].each do |role|
          mysql_grant_locations << role.host
        end unless roles[role_name].blank?
      end
      set :mysql_grant_locations, mysql_grant_locations
    end        
        
    put template.load("mysql/install_db.sql.erb"), "/tmp/install_db_#{application}.sql"    
    run "mysql -u root -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
