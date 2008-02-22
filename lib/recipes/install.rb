namespace :install do
  
  desc <<-DESC
  Run install recipes, as user.
  
  recipes: Recipes to run as part of install.    
    
    set :recipes, [ "centos:setup_for_web", "packages:install", "centos:ruby:install" ]
    
  install_user: The user to run as for install recipes. Defaults to root.
  
    set :install_user, "root"
    
  DESC
  task :default do
      
    # Settings
    fetch(:recipes)
    fetch_or_default(:install_user, "root")
        
    # Change user to install user for this recipes run
    set_user(install_user)      
        
    # These run after install task and install all the apps
    recipes.each do |task_name|
      after "install", task_name
    end
  end
  
end