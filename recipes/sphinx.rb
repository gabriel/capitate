# Sphinx recipes
namespace :sphinx do
  
  desc "Install sphinx"
  task :install do 
    package_install([ "gcc-c++" ])
    script_install("sphinx/install.sh")
  end
  
  desc "Setup sphinx for application"
  task :setup do 
    run "mkdir -p #{shared_path}/config"
    put load_template("sphinx/sphinx.conf.erb", binding), "#{shared_path}/config/sphinx.conf"    
  end
  
  desc "Update sphinx for application" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/sphinx.conf #{release_path}/config/sphinx.conf"
  end
  
end