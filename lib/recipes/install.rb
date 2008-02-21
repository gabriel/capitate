namespace :install do
  
  task :default do
      
    # Settings
    fetch(:recipes)
    fetch(:install_user)
    
    # Change user to install user for this recipes run
    set_user(install_user)    
    
    # These run after install task and install all the apps
    recipes.each do |task_name|
      after "install", task_name
    end
  end
  
end