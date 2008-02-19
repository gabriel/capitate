# Rails recipes
namespace :rails do
  
  desc "Create database yaml in shared path" 
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
