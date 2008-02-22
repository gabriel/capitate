# Rails recipes
namespace :rails do
  
  desc <<-DESC
  Create database yaml in shared path.
  
  db_name: Database name (rails).    
  
    set :db_name, "app_db_name"
  
  db_user: Database user (rails).    
  
    set :db_user, "app_db_user"
    
  db_pass: Database password (rails).    
  
    set :db_pass, "the_password"
    
  DESC
  task :setup do    
    
    # Settings
    fetch(:db_name)
    fetch(:db_user)
    fetch(:db_pass)
    
    run "mkdir -p #{shared_path}/config"
    put template.load("rails/database.yml.erb"), "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end
