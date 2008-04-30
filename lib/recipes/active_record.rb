namespace :active_record do
  
  desc <<-DESC
  Create (ActiveRecord) database yaml in shared path. 
  Note: If both @:db_host@ and @:db_socket@ are used, @db_socket@ wins.
  
  <dl>
  <dt>db_name</dt>
  <dd>Database name.</dd>  
  <dd>@set :db_name, "app_db_name"@</dd>
  
  <dt>db_user</dt>
  <dd>Database user.</dd>
  <dd>@set :db_user, "app_db_user"@</dd>    
  
  <dt>db_pass</dt>
  <dd>Database password.</dd>
  <dd>@set :db_pass, "the_password"@</dd>   
  
  <dt>db_host</dt>
  <dd>Database host (can be nil, if you are using socket).</dd>
  <dd class="default">Defaults to @nil@</dd>
  
  <dt>db_socket</dt>
  <dd>Database socket (can be nil, if you are using host).</dd>
  <dd class="default">Defaults to @nil@</dd>      
  <dd>@set :db_socket, "/var/lib/mysql/mysql.sock"@</dd>
  
  <dt>database_yml_template</dt>
  <dd>Path to database yml erb template.
  <dd class="default">Defaults to @rails/database.yml.erb@ (in this GEM)</dd>
  </dl>
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :setup, :roles => :app do    
    
    # Settings
    fetch(:db_name)
    fetch(:db_user)
    fetch(:db_pass)
    fetch_or_default(:db_host, nil)
    fetch_or_default(:db_socket, nil)
    fetch_or_default(:database_yml_template, "rails/database.yml.erb")
    
    unless db_host.blank?
      set :db_connect_type, "host"
      set :db_connect, db_host
    end
    
    unless db_socket.blank?
      set :db_connect_type, "socket"
      set :db_connect, db_socket
    end
    
    run "mkdir -p #{shared_path}/config"
    put template.load(database_yml_template), "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
  
end