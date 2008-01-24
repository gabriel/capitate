# Database recipes (rails)
namespace :database do
  
  desc "Create database yaml in shared path" 
  task :setup do    
    run "mkdir -p #{shared_path}/config"
    put load_template("rails/database.yml.erb", binding), "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end
