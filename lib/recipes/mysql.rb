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
  
  <dt>mysql_admin_password</dt>
  <dd>Mysql admin password (to use to connect).</dd>
  <dd>Defaults to password prompt.</dd>
  </dl>
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :setup, :roles => :db do    
    
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
      set :mysql_grant_locations, mysql_grant_locations.uniq!
    end 
    
    sql = template.load("mysql/install_db.sql.erb")       
    
    logger.trace "Running sql:\n#{sql}"
        
    put sql, "/tmp/install_db_#{application}.sql"    
    run "mysql -u root -p#{mysql_admin_password} < /tmp/install_db_#{application}.sql"
  end
  
end
