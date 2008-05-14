namespace :active_record do
  
  desc <<-DESC
  Create (ActiveRecord) database yaml in shared path. 
  Note: If both @:db_host@ and @:db_socket@ are used, @db_socket@ wins.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:db_name, "Database name")
  task_arg(:db_user, "Database user")
  task_arg(:db_pass, "Database password")
  task_arg(:db_host, "Database host", :default => nil)
  task_arg(:db_socket, "Database socket", :default => nil)
  task_arg(:database_yml_template, "Database yml template", :default => "rails/database.yml.erb")
  task :setup, :roles => :app do    
    
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