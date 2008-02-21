namespace :install do
  
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