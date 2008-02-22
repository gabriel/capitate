namespace :recipes do
  
  desc <<-DESC
  Run recipes, as user.
  
  *recipes_run*: Recipes to run.    
    
     set :recipes, [ "centos:setup_for_web", "packages:install", "ruby:centos:install" ]
    
  *recipes_user*: The user to run as for these recipes. Defaults to root.
  
     set :recipes_user, "root"
    
  DESC
  task :run do
      
    # Settings
    fetch(:recipes_run)
    fetch_or_default(:recipes_user, "root")
        
    # Change user to install user for this recipes run
    set_user(recipes_user)      
        
    # These run after install task and install all the apps
    recipes_run.each do |task_name|
      after "recipes:run", task_name
    end
  end
  
end