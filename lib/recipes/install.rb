namespace :install do
  
  task :default do
    # Choose profile, and load capistrano settings
    profile.ask
        
    # These run after install task and install all the apps
    recipes.each do |task_name|
      after "install", task_name
    end
  end
  
end