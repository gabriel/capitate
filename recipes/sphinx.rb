# Sphinx recipes
namespace :sphinx do
  
  task :setup do 
    run "mkdir -p #{shared_path}/config"
    put load_template("sphinx/sphinx.conf.erb", binding), "#{shared_path}/config/sphinx.conf"    
  end
  
  desc "Make symlink for sphinx conf" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/sphinx.conf #{release_path}/config/sphinx.conf"
  end
  
end